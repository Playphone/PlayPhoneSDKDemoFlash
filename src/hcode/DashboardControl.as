package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.MNDirectUIHelper;

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
            login.addEventListener(MouseEvent.CLICK, login_clickHandler);
            leaderboards.addEventListener(MouseEvent.CLICK, leaderboards_clickHandler);
            achievements.addEventListener(MouseEvent.CLICK, achievements_clickHandler);
            home.addEventListener(MouseEvent.CLICK, home_clickHandler);
        }

        private function login_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToUserLogin", null);
            MNDirectUIHelper.showDashboard();
        }

        private function leaderboards_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToLeaderboard", null);
            MNDirectUIHelper.showDashboard();        }

        private function achievements_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToAchievements", null);
            MNDirectUIHelper.showDashboard();        }

        private function home_clickHandler(event: MouseEvent): void
        {
            MNDirect.sendAppBeacon(null, null);
/*            MNDirect.execAppCommand("jumpToUserHome", null);
            MNDirectHelper.showDashboard();*/
        }
    }
}
