package hcode
{
    import spark.components.List;
    import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.providers.MNGameSettingsProvider
    import com.playphone.multinet.providers.MNPluginEvent

    import mx.collections.ArrayList
    import mx.events.FlexEvent


    public class Settings extends VGroup
    {
        public var settings_list:List;
        
        public function Settings()
        {
            super();
            this.addEventListener(FlexEvent.INITIALIZE, initializeHandler);
        }

        private function initializeHandler(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.INITIALIZE, initializeHandler);
            if (MNDirect.getSession() != null)
            {
                onSessionReady(null);
            }
            else
            {
                MNDirect.addEventListener(MNDirectEvent.onDirectSessionReady, onSessionReady);
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
            settings_list.dataProvider = new ArrayList(MNDirect.gameSettingsProvider.getGameSettingsList());
        }
    }
}
