package hcode
{
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.core.MNSession;
    import com.playphone.multinet.core.MNSessionEvent;

    import flash.events.Event;
    import flash.utils.ByteArray;

    import spark.components.Label;
    import spark.components.VGroup;
    import mx.events.FlexEvent

    public class AppInfo extends VGroup
    {

        public var version: Label;
        public var plist_url: Label
        public var web_url: Label
        public var sf_url: Label
        public var swf_metadata: Label

        public function AppInfo()
        {
            this.addEventListener(FlexEvent.INITIALIZE, initializeHandler);
        }

        private function initializeHandler(event: FlexEvent): void
        {
            //TODO: Do something with it

            this.removeEventListener(FlexEvent.INITIALIZE, initializeHandler);

            if (!MNDirect.getSession().isOnline())
            {
                MNDirect.getSession().addEventListener( MNSessionEvent.mnSessionConfigLoaded, onSettings );
            }
            else
            {
                onSettings(null);
            }
/*            version.text = MNSmartFoxFacade.myClient_version;

            var ba: ByteArray = (new SettingsLoader.plist()) as ByteArray;
            var s: String = ba.readUTFBytes(ba.length);
            var xml: XML = new XML(s);
            plist_url.text = xml.dict.string;*/

            var swfReader: SWFReader = new SWFReader(root.loaderInfo.bytes);
            var strMeta: String = swfReader.metadata.toXMLString();
            var start: int = strMeta.search("<dc:date>");
            var end: int = strMeta.search("</dc:date>");
            var date: String = strMeta.substring(start + 9, end);



            swf_metadata.text = date;
        }

        private function onSettings(event: MNSessionEvent): void
        {
            web_url.text = MNDirect.getSession().getWebServerURL();
//            sf_url.text = SettingsLoader.instance.smartfoxServerAddress + ":" + SettingsLoader.instance.smartfoxServerPort;
        }
    }
}
