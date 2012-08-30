package hcode
{
    import com.playphone.multinet.MNDirectButton;
    import com.playphone.multinet.MNDirectUIHelper;

    import flash.events.MouseEvent;

    import mx.events.FlexEvent;

    import spark.components.VGroup;
    import spark.components.Button;

    public class Dashboard extends VGroup
    {
        public var btnShow: Button;
        public var btnHide: Button;
        public var btnShowDashboard: Button;

        public function Dashboard()
        {
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            btnShow.addEventListener(MouseEvent.CLICK, btnShow_clickHandler);
            btnShowDashboard.addEventListener(MouseEvent.CLICK, btnShowDashboard_clickHandler);
            btnHide.addEventListener(MouseEvent.CLICK, btnHide_clickHandler);
        }

        private function btnShowDashboard_clickHandler(event: MouseEvent): void
        {
            MNDirectUIHelper.showDashboard();
        }

        private function btnHide_clickHandler(event: MouseEvent): void
        {
            MNDirectButton.hide();
        }

        private function btnShow_clickHandler(event: MouseEvent): void
        {
            MNDirectButton.show();
        }
    }
}
