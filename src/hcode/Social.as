package hcode
{
    import flash.events.MouseEvent;

    import mx.events.FlexEvent;

    import spark.components.Button;
    import spark.components.List;
    import spark.components.VGroup;

    import com.playphone.multinet.core.data.MNWSBuddyListItem
    import com.playphone.multinet.core.ws.MNWSDefHandlerEvent
    import com.playphone.multinet.core.ws.MNWSRequestContent
    import com.playphone.multinet.core.ws.MNWSRequestDefHandler
    import com.playphone.multinet.core.ws.MNWSRequestSender

    import mx.collections.ArrayList


    public class Social extends VGroup
    {
        private var req_block: String;
        public var btnGetIt: Button;
        public var list:List;

        public function Social()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            btnGetIt.addEventListener(MouseEvent.CLICK, btnGetIt_clickHandler);
        }

        private function btnGetIt_clickHandler(event: MouseEvent): void
        {
            var handler: MNWSRequestDefHandler = new MNWSRequestDefHandler();
            handler.addEventListener(MNWSDefHandlerEvent.onRequestComplete, onComplete);
            handler.addEventListener(MNWSDefHandlerEvent.onRequestError, onError);

            var content: MNWSRequestContent = new MNWSRequestContent();
            req_block = content.addCurrUserBuddyList();

            MNWSRequestSender.instance.sendRequest(content, handler);
        }

        private function onError(event: MNWSDefHandlerEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this, event.params.message);
        }

        private function onComplete(event: MNWSDefHandlerEvent): void
        {
            var buddies: Array = vectorToArray(event.params[req_block] as Vector.<MNWSBuddyListItem>);
            list.dataProvider = new ArrayList(buddies);
        }

        private function vectorToArray(v: Object): Array
        {
            var len: int = v.length;
            var ret: Array = new Array(len);
            for (var i: int = 0; i < len; ++i)
            {
                ret[i] = v[i];
            }
            return ret;
        }
    }
}
