package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.MNDirectEvent;
    import com.playphone.multinet.core.data.MNWSLeaderboardListItem;
    import com.playphone.multinet.core.ws.MNWSRequestContent;
    import com.playphone.multinet.providers.MNGameSettingsProvider;
    import com.playphone.multinet.providers.MNGameSettingsProviderEvent;
    import com.playphone.multinet.providers.requests.*;
    import com.playphone.multinet.providers.results.CurrentUserInfoRequestResult;
    import com.playphone.multinet.providers.results.LeaderboardRequestResult;
    import com.playphone.multinet.providers.results.RequestResult;

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
                MNDirect.addEventListener(MNDirectEvent.mnDirectSessionReady, onSessionReady);
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
            if (MNDirect.getGameSettingsProvider().isGameSettingListNeedUpdate())
            {
                MNDirect.getGameSettingsProvider().addEventListener(
                        MNGameSettingsProviderEvent.onGameSettingListUpdated, onSettingsReady)
                MNDirect.getGameSettingsProvider().doGameSettingListUpdate();
            }
            else
            {
                onSettingsReady(null);
            }
        }


        private function onSettingsReady(event: MNGameSettingsProviderEvent): void
        {
            var packs: Array = MNDirect.getGameSettingsProvider().getGameSettingList();
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

            var request: MNWSInfoRequestLeaderboard =
                    new MNWSInfoRequestLeaderboard
                        (new LeaderboardModeCurrentUser(scope_values[scope.selectedIndex],
                                                        period_values[period.selectedIndex]));
            request.addEventListener(RequestResult.REPLY, onComplete);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function onComplete(event: LeaderboardRequestResult): void
        {
            event.currentTarget.removeEventListener(RequestResult.REPLY, onComplete);
            if(event.hasError())
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
