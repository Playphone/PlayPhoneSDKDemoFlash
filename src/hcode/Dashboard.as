package hcode
{
    import flash.events.MouseEvent;

    import mx.events.FlexEvent;

    import com.playphone.multinet.MNDirectHelper
    import com.playphone.multinet.ui.common.MNDirectButton

    import spark.components.VGroup;
    import spark.components.Button;

    public class Dashboard extends VGroup
    {
        public var show_button: Button;
        public var hide_button: Button;
        public var show_dashboard: Button;

        public function Dashboard()
        {
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            show_button.addEventListener(MouseEvent.CLICK, show_button_clickHandler);
            show_dashboard.addEventListener(MouseEvent.CLICK, show_dashboard_clickHandler);
            hide_button.addEventListener(MouseEvent.CLICK, hide_button_clickHandler);
        }

        private function show_dashboard_clickHandler(event: MouseEvent): void
        {
            MNDirectHelper.showDashboard();
        }

        private function hide_button_clickHandler(event: MouseEvent): void
        {
            MNDirectButton.visible = false;
        }

        private function show_button_clickHandler(event: MouseEvent): void
        {
            MNDirectButton.visible = true;
        }
    }
}
