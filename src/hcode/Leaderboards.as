package hcode
{
    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.core.data.MNWSLeaderboardListItem
    import com.playphone.multinet.core.ws.MNWSDefHandlerEvent
    import com.playphone.multinet.core.ws.MNWSRequestContent
    import com.playphone.multinet.core.ws.MNWSRequestDefHandler
    import com.playphone.multinet.core.ws.MNWSRequestSender
    import com.playphone.multinet.providers.MNGameSettingsProvider
    import com.playphone.multinet.providers.MNPluginEvent

    import flash.events.MouseEvent;

    import mx.collections.ArrayList
    import mx.events.FlexEvent

    import spark.components.Button;
    import spark.components.CheckBox;
    import spark.components.List;
    import spark.components.TextInput;

    import spark.components.VGroup;

    import views.controls.DropDown;


    public class Leaderboards extends VGroup
    {
        public var load: Button;
        public var list: List;
        private var req_block: String;

        public var game_settings: TextInput;
        public var any_user_id: TextInput;
        public var any_user_box: CheckBox;
        public var any_game_id: TextInput;
        public var any_game_box: CheckBox;
        public var is_global: CheckBox;

        public function Leaderboards()
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
            MNDirect.setDefaultGameSetId(int(game_settings.text));

            var handler: MNWSRequestDefHandler = new MNWSRequestDefHandler();
            handler.addEventListener(MNWSDefHandlerEvent.onRequestComplete, onComplete);
            handler.addEventListener(MNWSDefHandlerEvent.onRequestError, onError);

            var leaderboardType: String = is_global.selected ? MNWSRequestContent.LEADERBOARD_SCOPE_GLOBAL : MNWSRequestContent.LEADERBOARD_SCOPE_LOCAL;
            var content: MNWSRequestContent = new MNWSRequestContent();

            if (any_game_box.selected)
            {
                if (any_user_box.selected)
                {
                    if (is_global.selected)
                    {
                        req_block = content.addAnyUserAnyGameLeaderboardGlobal(int(any_user_id.text),
                                                                               int(any_game_id.text),
                                                                               int(game_settings.text),
                                                                               MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME);
                    }
                }
                else
                {
                    if (!is_global.selected)
                    {
                        req_block = content.addCurrUserAnyGameLeaderboardLocal(int(any_game_id.text),
                                                                               int(game_settings.text),
                                                                               MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME);
                    }
                    else
                    {
                        req_block = content.addAnyGameLeaderboardGlobal(int(any_game_id.text),
                                                                               int(game_settings.text),
                                                                               MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME);
                    }
                }
            }
            else
            {
                if (!any_user_box.selected)
                {
                    if (is_global.selected)
                    {
                        req_block = content.addCurrUserLeaderboard(MNWSRequestContent.LEADERBOARD_SCOPE_GLOBAL,
                                                                   MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME);
                    }
                    else
                    {
                        req_block = content.addCurrUserLeaderboard(MNWSRequestContent.LEADERBOARD_SCOPE_LOCAL,
                                                                   MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME);
                    }
                }
            }

            MNWSRequestSender.instance.sendRequest(content, handler);
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

        private function onError(event: MNWSDefHandlerEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this, event.params.message);
        }
    }
}
