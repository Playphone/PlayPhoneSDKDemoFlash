package hcode
{
    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.MNDirectHelper
    import com.playphone.multinet.core.MNSession
    import com.playphone.multinet.core.MNSessionEvent

    import flash.events.MouseEvent;

    import mx.events.FlexEvent

    import spark.components.Button;
    import spark.components.Label;
    import spark.components.VGroup;

    public class Login extends VGroup
    {
        public var username: Label;
        public var login: Button;

        public function Login()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            this.addEventListener(FlexEvent.INITIALIZE, loginInitializeHandler);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            login.addEventListener(MouseEvent.CLICK, login_clickHandler);
        }

        private function login_clickHandler(event: MouseEvent): void
        {
            if (MNSession.instance.isLoggedIn)
            {
                MNSession.instance.logout();
            }
            else
            {
                MNDirectHelper.showDashboard();
            }
        }

        private function onLogin(event: MNSessionEvent): void
        {
            login.label = "Logout";
            username.text = MNSession.instance.getMyUserInfo().userName;
        }

        private function onLogout(event: MNSessionEvent): void
        {
            if (!MNSession.instance.isLoggedIn)
            {
                login.label = "Login";
                username.text = "";
            }
        }

        private function loginInitializeHandler(event: FlexEvent): void
        {
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
            MNSession.instance.addEventListener(MNSessionEvent.onDidLogin, onLogin);
            MNSession.instance.addEventListener(MNSessionEvent.onSessionStatusChanged, onLogout);

            if (MNSession.instance.isLoggedIn)
            {
                onLogin(null);
            }
        }
    }
}
