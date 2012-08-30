package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.MNDirectEvent;
    import com.playphone.multinet.core.MNSession;
    import com.playphone.multinet.providers.MNGameCookiesProvider;
    import com.playphone.multinet.providers.MNGameRoomCookiesProvider;
    import com.playphone.multinet.providers.MNGameRoomCookiesProviderEvent;

    import flash.events.Event;

    import flash.events.MouseEvent;

    import mx.events.FlexEvent;

    import spark.components.Button;

    import spark.components.TextInput;

    import spark.components.VGroup;

    public class RoomCookies extends VGroup
    {
        public var room_cookie_key: TextInput;
        public var room_cookie_val: TextInput;
        public var btnUpload: Button;
        public var download_cookie_key: TextInput;
        public var btnReload: Button;

        public function RoomCookies()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.mnDirectSessionReady, onSessionReady);
            }
            else
            {
                onSessionReady(null);
            }

            btnUpload.addEventListener(MouseEvent.CLICK, btnUpload_clickHandler);
            btnReload.addEventListener(MouseEvent.CLICK, btnReload_clickHandler)

        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            MNDirect.getGameRoomCookiesProvider().addEventListener(
                    MNGameRoomCookiesProviderEvent.onGameRoomCookieDownloadFailedWithError, downloadError);
            MNDirect.getGameRoomCookiesProvider().addEventListener(
                    MNGameRoomCookiesProviderEvent.onGameRoomCookieDownloadSucceeded, downloadComplete);
        }

        private function btnUpload_clickHandler(event: MouseEvent): void
        {
            if (MNDirect.getSession() != null)
            {
                if (MNDirect.getSession().isUserLoggedIn())
                {
                    MNDirect.getGameRoomCookiesProvider().setCurrentGameRoomCookie(int(room_cookie_key.text),
                                                                                   room_cookie_val.text);
                }
                else
                {
                    PlayPhoneSDKDemoFlash.showMessage(this, "User should be logged in!");
                }
            }
            else
            {
                PlayPhoneSDKDemoFlash.showMessage(this, "MNSession is not initialized!");
            }
        }

        private function btnReload_clickHandler(event: MouseEvent): void
        {
            if (MNDirect.getSession() != null)
            {
                if (MNDirect.getSession().isUserLoggedIn())
                {
                    MNDirect.getGameRoomCookiesProvider().downloadGameRoomCookie(MNDirect.getSession().getCurrentRoomId(), int(download_cookie_key.text));
                }
                else
                {
                    PlayPhoneSDKDemoFlash.showMessage(this, "User should be logged in!");
                }
            }
            else
            {
                PlayPhoneSDKDemoFlash.showMessage(this, "MNSession is not initialized!");
            }
        }

        private function downloadError(event: MNGameRoomCookiesProviderEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this,
                                              "Could not download cookie (id=" + event.params.key + ") " + event.params.error);
        }

        private function downloadComplete(event: MNGameRoomCookiesProviderEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this,
                                              "Cookie (id=" + event.params.key + " value=" + event.params.cookie + ") download succsessfuly");
        }
    }
}
