package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.core.MNSession;
    import com.playphone.multinet.core.data.MNWSLeaderboardListItem;
    import com.playphone.multinet.core.ws.MNWSRequestContent;
    import com.playphone.multinet.providers.results.LeaderboardRequestResult;
    import com.playphone.multinet.providers.results.RequestResult;

import com.playphone.multinet.providers.requests.*

    import flash.events.MouseEvent;

    import mx.collections.ArrayList;

    import mx.events.FlexEvent;

    import spark.components.Button;
    import spark.components.List;
    import spark.components.TabBar;
    import spark.components.TextInput;
    import spark.components.VGroup;

    public class UserLeaderboard extends VGroup
    {
        private var req_block: String;

        private static var period_values: Array = [MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME,
                                                   MNWSRequestContent.LEADERBOARD_PERIOD_THIS_WEEK,
                                                   MNWSRequestContent.LEADERBOARD_PERIOD_THIS_MONTH];

        public var scope: TabBar;
        public var game: TabBar;
        public var game_id: TextInput;

        public var period: TabBar;
        public var gameset_id: TextInput;
        public var load: Button;

        public var list: List;

        public function UserLeaderboard()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            load.addEventListener(MouseEvent.CLICK, load_clickHandler);
        }


        private function load_clickHandler(event: MouseEvent): void
        {
            MNDirect.setDefaultGameSetId(int(gameset_id.text));

            var game_id_val: int;

            if (game.selectedIndex == 1)
            {
                game_id_val = int(game_id.text);
            }
            else
            {
                game_id_val = MNDirect.getSession().getGameId();
            }


            if (scope.selectedIndex == 1)
            {
                var localRequest: MNWSInfoRequestLeaderboard =
                        new MNWSInfoRequestLeaderboard(
                            new LeaderboardModeCurrUserAnyGameLocal(
                                game_id_val,
                                int(gameset_id.text),
                                period_values[period.selectedIndex]));

                localRequest.addEventListener(RequestResult.REPLY, onComplete);

                MNDirect.getWSProvider().sendSingle(localRequest);
            }
            else
            {
                var request: MNWSInfoRequestLeaderboard =
                        new MNWSInfoRequestLeaderboard(
                            new LeaderboardModeAnyGameGlobal(
                                game_id_val,
                                int(gameset_id.text),
                                period_values[period.selectedIndex]));

                request.addEventListener(RequestResult.REPLY, onComplete);

                MNDirect.getWSProvider().sendSingle(request);
            }
        }

        private function onComplete(event: LeaderboardRequestResult): void
        {
            event.currentTarget.removeEventListener(RequestResult.REPLY, onComplete);
            if (event.hasError())
            {
                PlayPhoneSDKDemoFlash.showMessage(this, event.getErrorMessage());
            }
            else
            {
                var leaderboard: Vector.<MNWSLeaderboardListItem> = event.getDataEntry();
                list.dataProvider = new ArrayList(vectorToArray(leaderboard));
            }
        }

        private function vectorToArray(v: Object): Array
        {
            var len: int = v.length;
            var ret: Array = new Array(len);
            for (var i: int = 0; i < len; ++i)
            {
                ret[i] = v[i];
            }
            return ret;
        }

    }
}
