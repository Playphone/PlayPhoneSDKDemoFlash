package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.core.MNSession;
    import com.playphone.multinet.core.data.MNWSLeaderboardListItem;
    import com.playphone.multinet.core.ws.MNWSDefHandlerEvent;
    import com.playphone.multinet.core.ws.MNWSRequestContent;
    import com.playphone.multinet.core.ws.MNWSRequestDefHandler;
    import com.playphone.multinet.core.ws.MNWSRequestSender;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.collections.ArrayList;

    import mx.events.FlexEvent;

    import spark.components.Button;
    import spark.components.List;

    import spark.components.TabBar;
    import spark.components.TextInput;

    import spark.components.VGroup;

    public class GameLeaderboard extends VGroup
    {
        private var req_block: String;

        private static var scope_values: Array = [MNWSRequestContent.LEADERBOARD_SCOPE_GLOBAL,
                                                  MNWSRequestContent.LEADERBOARD_SCOPE_LOCAL];
        private static var period_values: Array = [MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME,
                                                   MNWSRequestContent.LEADERBOARD_PERIOD_THIS_WEEK,
                                                   MNWSRequestContent.LEADERBOARD_PERIOD_THIS_MONTH];

        public var player: TabBar;
        public var user_id: TextInput;
        public var game: TabBar;
        public var game_id: TextInput;

        public var period: TabBar;
        public var gameset_id: TextInput;
        public var load: Button;

        public var list: List;

        public function GameLeaderboard()
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

            var handler: MNWSRequestDefHandler = new MNWSRequestDefHandler();
            handler.addEventListener(MNWSDefHandlerEvent.onRequestComplete, onComplete);
            handler.addEventListener(MNWSDefHandlerEvent.onRequestError, onError);

            var content: MNWSRequestContent = new MNWSRequestContent();
            var user_id_val: int;
            var game_id_val: int;

            if (player.selectedIndex == 1)
            {
                user_id_val = int(user_id.text);
            }
            else
            {
                user_id_val = MNSession.instance.getMyUserId();
            }

            if (game.selectedIndex == 1)
            {
                game_id_val = int(game_id.text);
            }
            else
            {
                game_id_val = MNSession.instance.getGameId();
            }

            req_block = content.addAnyUserAnyGameLeaderboardGlobal(user_id_val,
                                                                   game_id_val,
                                                                   int(gameset_id),
                                                                   period_values[period.selectedIndex]);

            MNWSRequestSender.instance.sendRequest(content, handler);
        }

        private function onError(event: MNWSDefHandlerEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this, event.params.message);
        }

        private function onComplete(event: MNWSDefHandlerEvent): void
        {
            var leaderboard: Vector.<MNWSLeaderboardListItem> = event.params[req_block] as Vector.<MNWSLeaderboardListItem>;
            list.dataProvider = new ArrayList(vectorToArray(leaderboard));
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
