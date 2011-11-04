package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.MNDirectEvent;
    import com.playphone.multinet.core.data.MNWSLeaderboardListItem;
    import com.playphone.multinet.core.ws.MNWSDefHandlerEvent;
    import com.playphone.multinet.core.ws.MNWSRequestContent;
    import com.playphone.multinet.core.ws.MNWSRequestDefHandler;
    import com.playphone.multinet.core.ws.MNWSRequestSender;
    import com.playphone.multinet.providers.MNGameSettingsProvider;
    import com.playphone.multinet.providers.MNPluginEvent;

    import flash.events.MouseEvent;

    import mx.collections.ArrayList;

    import mx.events.FlexEvent;

    import spark.components.Button;
    import spark.components.List;
    import spark.components.TabBar;
    import spark.components.TextInput;
    import spark.components.VGroup;

    import views.controls.DropDown;

    public class OldLeaderboard extends VGroup
    {
        private var req_block: String;

        private static var scope_values:Array = [MNWSRequestContent.LEADERBOARD_SCOPE_GLOBAL,
                                                 MNWSRequestContent.LEADERBOARD_SCOPE_LOCAL];
        private static var period_values:Array = [MNWSRequestContent.LEADERBOARD_PERIOD_ALL_TIME,
                                                  MNWSRequestContent.LEADERBOARD_PERIOD_THIS_WEEK,
                                                  MNWSRequestContent.LEADERBOARD_PERIOD_THIS_MONTH];

        public var score: TextInput;
        public var settings: DropDown;
        public var load: Button;
        public var list: List;

        public var scope:TabBar;
        public var period:TabBar;

        public function OldLeaderboard()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            load.addEventListener(MouseEvent.CLICK, load_clickHandler);

            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.onDirectSessionReady, onSessionReady);
            }
            else
            {
                onSessionReady(null);
            }
        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            checkSettings();
        }

        private function checkSettings(): void
        {
            if (MNDirect.gameSettingsProvider.isGameSettingListNeedUpdate())
            {
                MNDirect.gameSettingsProvider.addEventListener(MNGameSettingsProvider.onGameSettingsListDownloaded,
                                                               onSettingsReady)
                MNDirect.gameSettingsProvider.doGameSettingListUpdate();
            }
            else
            {
                onSettingsReady(null);
            }
        }


        private function onSettingsReady(event: MNPluginEvent): void
        {
            var packs: Array = MNDirect.gameSettingsProvider.getGameSettingsList();
            var setting_items: Array = [];
            for each(var pack: Object in packs)
            {
                if (pack.name != null)
                {
                    setting_items.push({label:pack.name, data:pack});
                }
                else
                {
                    setting_items.push({label:"Default", data:pack});
                }
            }

            settings.dataProvider = new ArrayList(setting_items);
            settings.selectedIndex = 0;
        }

        private function load_clickHandler(event: MouseEvent): void
        {
            var selectedItem: Object = settings.dataProvider.getItemAt(settings.selectedIndex);
            MNDirect.setDefaultGameSetId(selectedItem.data.id);

            var handler: MNWSRequestDefHandler = new MNWSRequestDefHandler();
            handler.addEventListener(MNWSDefHandlerEvent.onRequestComplete, onComplete);
            handler.addEventListener(MNWSDefHandlerEvent.onRequestError, onError);

            var content: MNWSRequestContent = new MNWSRequestContent();
            req_block = content.addCurrUserLeaderboard( scope_values[scope.selectedIndex], period_values[period.selectedIndex] );
            MNWSRequestSender.instance.sendRequest( content, handler );
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
