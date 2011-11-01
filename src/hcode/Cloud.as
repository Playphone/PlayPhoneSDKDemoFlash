/**
 * Created by IntelliJ IDEA.
 * User: AUsachov
 * Date: 11/1/11
 * Time: 1:12 PM
 * To change this template use File | Settings | File Templates.
 */
package hcode
{
    import flash.events.MouseEvent;

    import spark.components.Button;

    import spark.components.TextInput;

    import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.core.MNSession
    import com.playphone.multinet.providers.MNGameCookiesProvider
    import com.playphone.multinet.providers.MNPluginEvent

    import mx.events.FlexEvent

    public class Cloud extends VGroup
    {
        public var cookie_key: TextInput;
        public var cookie_val: TextInput;
        public var upload: Button;
        public var dwcookie_key: TextInput;
        public var reload: Button;

        public function Cloud()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            this.addEventListener(FlexEvent.INITIALIZE, initializeHandler );
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            upload.addEventListener( MouseEvent.CLICK, button1_clickHandler );
            reload.addEventListener( MouseEvent.CLICK, button2_clickHandler );
        }

        private function button1_clickHandler(event: MouseEvent): void
        {
            if (MNDirect.getSession() != null)
            {
                if (MNSession.instance.isLoggedIn)
                {
                    MNDirect.gameCookiesProvider.uploadUserCookie(int(cookie_key.text), cookie_val.text);
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

        private function initializeHandler(event: FlexEvent): void
        {
            trace("Login initializeHandler");
            this.removeEventListener(FlexEvent.INITIALIZE, initializeHandler );
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
            MNDirect.gameCookiesProvider.addEventListener(MNGameCookiesProvider.onGameCookieDownloadFailedWithError,
                                                          downloadError);
            MNDirect.gameCookiesProvider.addEventListener(MNGameCookiesProvider.onGameCookieDownloadSucceeded,
                                                          downloadComplete);
            MNDirect.gameCookiesProvider.addEventListener(MNGameCookiesProvider.onGameCookieUploadFailedWithError,
                                                          uploadError);
            MNDirect.gameCookiesProvider.addEventListener(MNGameCookiesProvider.onGameCookieUploadSucceeded,
                                                          uploadComplete);
        }

        private function downloadError(event: MNPluginEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this,
                                              "Could not download cookie (id=" + event.params.key + ") " + event.params.error);
        }

        private function downloadComplete(event: MNPluginEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this,
                                              "Cookie (id=" + event.params.key + " value=" + event.params.cookie + ") download succsessfuly");
        }

        private function uploadError(event: MNPluginEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this,
                                              "Could not upload cookie (id=" + event.params.key + ") " + event.params.error);
        }

        private function uploadComplete(event: MNPluginEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this, "Cookie uploaded succsessfuly");
        }

        private function button2_clickHandler(event: MouseEvent): void
        {
            if (MNDirect.getSession() != null)
            {
                if (MNSession.instance.isLoggedIn)
                {
                    MNDirect.gameCookiesProvider.downloadUserCookie(int(dwcookie_key.text));
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

    }
}
