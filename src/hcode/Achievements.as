package hcode
{
    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.providers.MNAchievementsProvider
    import com.playphone.multinet.providers.MNAchievementsProviderEvent;

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
        public var achievement_id: TextInput;
        public var btnUnlock: Button;
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
            btnUnlock.addEventListener(MouseEvent.CLICK, btnUnlock_clickHandler);
        }

        private function initializeHandler(event: FlexEvent): void
        {
            if (MNDirect.getSession() != null)
            {
                checkAchievements();
            }
            else
            {
                MNDirect.addEventListener(MNDirectEvent.mnDirectSessionReady, onSessionReady);
            }
        }

        private function checkAchievements(): void
        {
            if (MNDirect.getAchievementsProvider().isGameAchievementListNeedUpdate())
            {
                MNDirect.getAchievementsProvider().addEventListener(MNAchievementsProviderEvent.onGameAchievementListUpdated, onListUpdated);
                MNDirect.getAchievementsProvider().doGameAchievementListUpdate();
            }
            else
            {
                fillAchievements();
            }
        }

        private function fillAchievements(): void
        {
            var achievements:Array = MNDirect.getAchievementsProvider().getGameAchievementsList();
            achievements_list.dataProvider = new ArrayCollection(achievements);
        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            checkAchievements();
        }

        private function onListUpdated(event: Event): void
        {
            fillAchievements();
        }

        private function btnUnlock_clickHandler(event: MouseEvent): void
        {
            MNDirect.getAchievementsProvider().unlockPlayerAchievement(int(achievement_id.text));
        }
    }
}
