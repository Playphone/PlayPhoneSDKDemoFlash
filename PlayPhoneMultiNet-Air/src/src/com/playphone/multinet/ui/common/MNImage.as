package com.playphone.multinet.ui.common
{
    import flash.display.DisplayObject
    import flash.display.Loader
    import flash.display.MovieClip
    import flash.events.Event
    import flash.events.IOErrorEvent
    import flash.net.URLLoader
    import flash.net.URLLoaderDataFormat
    import flash.net.URLRequest
    import flash.utils.ByteArray

    public class MNImage
    {
        protected var visualContent: DisplayObject;
        private var pictObject: DisplayObject;
        private var baseAvatarWidth: int;
        private var baseAvatarHeight: int;
        private var empty: DisplayObject;

        public function MNImage(content: DisplayObject, additionalParams: Object = null)
        {
            visualContent = content;
            baseAvatarWidth = content.width;
            baseAvatarHeight = content.height;
            empty = (visualContent as MovieClip).removeChildAt(0);
        }

        public function loadFromRes(img:MovieClip):void
        {
            (visualContent as MovieClip).addChild(img);
        }

        public function loadImage(url: String): void
        {
            if (url != "")
            {
                clearChildren();
                var loader: URLLoader = new URLLoader();
                var request: URLRequest = new URLRequest(url);

                loader.addEventListener(Event.COMPLETE, onAvatarLoaded);
                loader.addEventListener(IOErrorEvent.IO_ERROR, onRequestIOError);
                loader.dataFormat = URLLoaderDataFormat.BINARY;

                try
                {
                    loader.load(request);
                }
                catch (error: Error)
                {
                    //TODO: Add error message drop
                    trace("MNImage.loadImage error: " + error.message);
                }
            }
            else
            {
                (visualContent as MovieClip).addChild(empty);
            }
        }

        private function clearChildren(): void
        {
            var childNumber: int = (visualContent as MovieClip).numChildren;
            for (var i: int = 0; i < childNumber; i++)
            {
                (visualContent as MovieClip).removeChildAt(0);
            }
        }

        private function onRequestIOError(evt: IOErrorEvent): void
        {
            //TODO: Add error message drop
            (visualContent as MovieClip).addChild(empty);
            trace("MNImage.onRequestIOError error: " + evt.text);
        }

        private function onAvatarLoaded(evt: Event): void
        {
            var load: URLLoader = URLLoader(evt.target);
            var loader: Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCmplete);
            loader.loadBytes(load.data as ByteArray);
            pictObject = (visualContent as MovieClip).addChild(loader);
        }

        public function onLoadCmplete(evt: Event): void
        {
            pictObject.scaleX = baseAvatarWidth / pictObject.width;
            pictObject.scaleY = baseAvatarHeight / pictObject.height;
        }
    }
}