package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.MNDirectHelper;

    import flash.events.MouseEvent;

    import mx.events.FlexEvent;

    import spark.components.Button;
    import spark.components.VGroup;

    public class DashboardControl extends VGroup
    {
        public var login: Button;
        public var leaderboards: Button;
        public var achievements: Button;
        public var home: Button;

        public function DashboardControl()
        {
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            login.addEventListener(MouseEvent.CLICK, button1_clickHandler);
            leaderboards.addEventListener(MouseEvent.CLICK, button2_clickHandler);
            achievements.addEventListener(MouseEvent.CLICK, button3_clickHandler);
            home.addEventListener(MouseEvent.CLICK, button4_clickHandler);
        }

        private function button1_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToUserLogin", null);
            MNDirectHelper.showDashboard();
        }

        private function button2_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToLeaderboard", null);
            MNDirectHelper.showDashboard();
        }

        private function button3_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToAchievements", null);
            MNDirectHelper.showDashboard();
        }

        private function button4_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToUserHome", null);
            MNDirectHelper.showDashboard();
        }
    }
}
