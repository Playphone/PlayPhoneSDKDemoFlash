package hcode
{
    import mx.events.FlexEvent;

    import spark.components.VGroup;

    public class RoomCookies extends VGroup
    {
        public function RoomCookies()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }
    }
}
