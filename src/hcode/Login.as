package hcode
{
    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.MNUserInfo;
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
            if (MNDirect.getSession().isUserLoggedIn())
            {
                MNDirect.getSession().logout();
            }
            else
            {
//                MNDirectHelper.showDashboard();
                MNDirect.getSession().loginWithUserLoginAndPassword("u1001@sample.com", "u1001", false);
            }
        }

        private function onLogin(event: MNSessionEvent): void
        {
            if(MNDirect.getSession().isUserLoggedIn())
            {
                MNDirect.getSession().addEventListener(MNSessionEvent.mnSessionStatusChanged, onLogout);
                MNDirect.getSession().removeEventListener(MNSessionEvent.mnSessionStatusChanged, onLogin);
                login.label = "Logout";
                var my:MNUserInfo = MNDirect.getSession().getMyUserInfo();
                username.text = my.userName;
            }
        }

        private function onLogout(event: MNSessionEvent): void
        {
            if (!MNDirect.getSession().isUserLoggedIn())
            {
                MNDirect.getSession().removeEventListener(MNSessionEvent.mnSessionStatusChanged, onLogout);
                MNDirect.getSession().addEventListener(MNSessionEvent.mnSessionStatusChanged, onLogin);
                login.label = "Login";
                username.text = "";
//                username.enabled = true;
//                pass.enabled = true;
            }
        }

        private function loginInitializeHandler(event: FlexEvent): void
        {
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
            MNDirect.getSession().addEventListener(MNSessionEvent.mnSessionStatusChanged, onLogin);

            if (MNDirect.getSession().isUserLoggedIn())
            {
                onLogin(null);
            }
        }
    }
}
