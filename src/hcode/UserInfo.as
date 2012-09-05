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

    import com.playphone.multinet.core.data.*;
    import com.playphone.multinet.providers.requests.*;
    import com.playphone.multinet.providers.results.*;

    import com.playphone.multinet.providers.*;

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

        private function onLogin(event: MNSessionEvent): void
        {
            if( MNDirect.getSession().isUserLoggedIn() )
            {
                MNDirect.getSession().removeEventListener(MNSessionEvent.mnSessionStatusChanged, onLogin);
                MNDirect.getSession().addEventListener(MNSessionEvent.mnSessionStatusChanged, onLogout);
                var userInfo: MNUserInfo = MNDirect.getSession().getMyUserInfo();
                room_id.text = String(MNDirect.getSession().getCurrentRoomId());
                user_name.text = userInfo.userName;
                user_id.text = String(userInfo.userId);
                user_img.source = userInfo.userAvatarUrl;
            }
        }

/*        private function onComplete(event: AnyGameRequestResult): void
        {
            var game_id: int          = event.getDataEntry().game_id;
            var game_name: String     = event.getDataEntry().game_name;
            var game_desc: String     = event.getDataEntry().game_desc;
            var gamegenre_id: int     = event.getDataEntry().gamegenre_id;
            var game_flags: Number    = event.getDataEntry().game_flags;
            var game_status: int      = event.getDataEntry().game_status;
            var game_play_model: int  = event.getDataEntry().game_play_model;
            var game_icon_url: String = event.getDataEntry().game_icon_url;
            var developer_id: Number  = event.getDataEntry().developer_id;

            trace("AnyGameRequestResult:");
            trace("game_id="+game_id);
            trace("game_name="+game_name);
            trace("game_desc="+game_desc);
            trace("gamegenre_id="+gamegenre_id);
            trace("game_flags="+game_flags);
            trace("game_status="+game_status);
            trace("game_play_model="+game_play_model);
            trace("game_icon_url="+game_icon_url);
            trace("developer_id="+developer_id);
        }*/

        private function onLogout(event: MNSessionEvent): void
        {
            if (!MNDirect.getSession().isUserLoggedIn())
            {
                onSessionReady(null);
                room_id.text = "-1";
                user_name.text = "---";
                user_id.text = "-1";
            }
        }
    }
}
