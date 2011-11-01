/**
 * Created by IntelliJ IDEA.
 * User: AUsachov
 * Date: 11/1/11
 * Time: 1:27 PM
 * To change this template use File | Settings | File Templates.
 */
package hcode
{
    import flash.events.Event;
    import flash.utils.ByteArray;

    import spark.components.Label;
    import spark.components.VGroup;

    import com.playphone.multinet.core.MNSmartFoxFacade
    import com.playphone.multinet.utils.SettingsLoader

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
            this.removeEventListener(FlexEvent.INITIALIZE, initializeHandler);
            if (!SettingsLoader.instance.isLoaded)
            {
                SettingsLoader.instance.addEventListener(Event.COMPLETE, onSettings);
            }
            else
            {
                onSettings(null);
            }
            version.text = MNSmartFoxFacade.myClient_version;

            var ba: ByteArray = (new SettingsLoader.plist()) as ByteArray;
            var s: String = ba.readUTFBytes(ba.length);
            var xml: XML = new XML(s);
            plist_url.text = xml.dict.string;

            var swfReader: SWFReader = new SWFReader(root.loaderInfo.bytes);

            var strMeta: String = swfReader.metadata.toXMLString();
            var start: int = strMeta.search("<dc:date>");
            var end: int = strMeta.search("</dc:date>");
            var date: String = strMeta.substring(start + 9, end);

            swf_metadata.text = date;
        }

        private function onSettings(event: Event): void
        {
            web_url.text = SettingsLoader.instance.multiNetWebSererverURL;
            sf_url.text = SettingsLoader.instance.smartfoxServerAddress + ":" + SettingsLoader.instance.smartfoxServerPort;
        }
    }
}
