package hcode
{
    import mx.events.FlexEvent;

    import spark.components.Image;
    import spark.components.Label;

    import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.MNUserInfo
    import com.playphone.multinet.core.MNSession
    import com.playphone.multinet.core.MNSessionEvent

    import mx.events.FlexEvent


    public class UserInfo extends VGroup
    {
        public var user_img:Image;
        public var user_name:Label;
        public var user_id:Label;
        public var room_id:Label;

        public function UserInfo()
        {
            super();
            this.addEventListener(FlexEvent.INITIALIZE, userinfoInitializeHandler);
        }

        public function userinfoInitializeHandler(event: FlexEvent): void
        {
            trace("Userinfo initializeHandler");
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
            if (MNSession.instance.isLoggedIn)
            {
                onLogin(null);
            }
        }

        private function onLogin(event: MNSessionEvent): void
        {
            MNSession.instance.removeEventListener(MNSessionEvent.onDidLogin, onLogin);
            MNSession.instance.addEventListener(MNSessionEvent.onSessionStatusChanged, onLogout);
            var userinfo: MNUserInfo = MNSession.instance.getMyUserInfo();
            room_id.text = String(MNSession.instance.getCurrentRoomId());
            user_name.text = userinfo.userName;
            user_id.text = String(userinfo.userId);
            user_img.source = userinfo.userAvatar;
        }

        private function onLogout(event: MNSessionEvent): void
        {
            if (!MNSession.instance.isLoggedIn)
            {
                onSessionReady(null);
                room_id.text = "-1";
                user_name.text = "---";
                user_id.text = "-1";
            }
        }
    }
}
