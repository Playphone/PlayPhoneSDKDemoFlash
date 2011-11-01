package hcode
{
    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.providers.MNAchievementsProvider

    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.collections.ArrayCollection

    import mx.events.FlexEvent

    import spark.components.Button;
    import spark.components.List;
    import spark.components.TextInput;

    import spark.components.VGroup;

    public class Achievements extends VGroup
    {
        public var ach_id: TextInput;
        public var unlock: Button;
        public var achievements_list: List;

        public function Achievements()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            this.addEventListener(FlexEvent.INITIALIZE, initializeHandler);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            unlock.addEventListener(MouseEvent.CLICK, button1_clickHandler);
        }

        private function initializeHandler(event: FlexEvent): void
        {
            if (MNDirect.getSession() != null)
            {
                checkAchievements();
            }
            else
            {
                MNDirect.addEventListener(MNDirectEvent.onDirectSessionReady, onSessionReady);
            }
        }

        private function checkAchievements(): void
        {
            if (MNDirect.achievementsProvider.isGameAchievementListNeedUpdate)
            {
                MNDirect.achievementsProvider.addEventListener(MNAchievementsProvider.onGameAchievementListDownloaded,
                                                               onListUpdated);
                MNDirect.achievementsProvider.doGameAchievementListUpdate();
            }
            else
            {
                fillAchievements();
            }
        }

        private function fillAchievements(): void
        {
            achievements_list.dataProvider = new ArrayCollection(MNDirect.achievementsProvider.getGameAchievementsList());
        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            checkAchievements();
        }

        private function onListUpdated(event: Event): void
        {
            fillAchievements();
        }

        private function button1_clickHandler(event: MouseEvent): void
        {
            MNDirect.achievementsProvider.unlockPlayerAchievement(int(ach_id.text));
        }
    }
}
