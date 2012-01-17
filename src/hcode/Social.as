package hcode
{
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

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
        private var fill_timer:Timer;
        private var buddies:Vector.<MNWSBuddyListItem>;

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
            buddies = event.params[req_block] as Vector.<MNWSBuddyListItem>;
            if( buddies != null )
            {
                if( buddies.length > 1 )
                {
                    fill_timer = new Timer(50, buddies.length - 1);
                    fill_timer.addEventListener( TimerEvent.TIMER, onAddNextPortion);
                    fill_timer.addEventListener( TimerEvent.TIMER_COMPLETE, onFillComplete );
                    fill_timer.start();
                }
                list.dataProvider = new ArrayList([buddies.shift()]);
            }
        }

        private function onFillComplete(event: TimerEvent): void
        {
            fill_timer.stop();
            fill_timer.removeEventListener( TimerEvent.TIMER, onAddNextPortion);
            fill_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onFillComplete );
            fill_timer = null;
            buddies = null;
        }

        private function onAddNextPortion(event: TimerEvent): void
        {
            if( buddies.length > 0 )
            {
                list.dataProvider.addItem( buddies.shift() );
            }
            else
            {
                onFillComplete(null);
            }
        }
    }
}
