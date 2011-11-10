package hcode
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import mx.events.ResizeEvent;

    import spark.components.Button;
    import spark.components.Label;

    import spark.components.VGroup;

    import com.playphone.multinet.MNConst;
    import com.playphone.multinet.MNDirect;
    import com.playphone.multinet.MNDirectEvent;
    import com.playphone.multinet.MNDirectHelper;
    import com.playphone.multinet.core.MNSession;
    import com.playphone.multinet.core.MNSessionEvent;
    import com.playphone.multinet.ui.common.MNScoreProgressView;

    import mx.events.FlexEvent;

    import spark.core.SpriteVisualElement;


    public class Multinet extends VGroup
    {
        private var scoreProgress: MNScoreProgressView;
        private var totalScore: int = 0;
        private var countdown: Timer;
        private var counter: int = -1;

        public var place: SpriteVisualElement;
        public var home: Button;
        public var m_ten: Button;
        public var p_ten: Button;
        public var counter_lbl: Label;

        public function Multinet()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
            this.addEventListener(ResizeEvent.RESIZE, resizeHandler)
        }

        private function creationCompleteHandler(event: FlexEvent): void
        {
            MNSession.instance.addEventListener(MNSessionEvent.onSessionStatusChanged, onSessionStatusChangedHandler);
            MNDirect.addEventListener(MNDirectEvent.onDoFinishGame, MNDirect_onDoFinishGameHandler);
            MNDirect.addEventListener(MNDirectEvent.onDoCancelGame, MNDirect_onDoCancelGameHandler);

            home.addEventListener(MouseEvent.CLICK, home_clickHandler);
            m_ten.addEventListener(MouseEvent.CLICK, m_ten_clickHandler);
            p_ten.addEventListener(MouseEvent.CLICK, p_ten_clickHandler);

            var shape: MovieClip = new MovieClip();
            shape.graphics.beginFill(0x000000, 0);
            shape.graphics.drawRect(0, 0, stage.stageWidth, 120);
            shape.graphics.endFill();

            place.width = stage.stageWidth;
            place.addChild(shape);


            scoreProgress = new MNScoreProgressView(shape);
            onSessionStatusChangedHandler(null);
        }


        private function home_clickHandler(event: MouseEvent): void
        {
            MNDirect.execAppCommand("jumpToUserHome", null);
            MNDirectHelper.showDashboard();
        }

        private function onSessionStatusChangedHandler(event: MNSessionEvent): void
        {
            if (MNSession.instance.getStatus() == MNConst.MN_IN_GAME_PLAY)
            {
                MNDirectHelper.hideDashboard();
                countdown = new Timer(1000, 60);
                counter = 60;
                counter_lbl.text = counter.toString();
                countdown.addEventListener(TimerEvent.TIMER, countdown_timerHandler);
                countdown.addEventListener(TimerEvent.TIMER_COMPLETE, countdown_timerCompleteHandler)
                countdown.start();
            }
        }

        private function MNDirect_onDoFinishGameHandler(event: MNDirectEvent): void
        {
            MNDirect.postGameScore(totalScore);
            totalScore = 0;
        }

        private function MNDirect_onDoCancelGameHandler(event: MNDirectEvent): void
        {
            totalScore = 0;
        }

        private function countdown_timerHandler(event: TimerEvent): void
        {
            counter_lbl.text = counter.toString();
            counter--;
        }

        private function countdown_timerCompleteHandler(event: TimerEvent): void
        {
            countdown.stop();
            countdown.removeEventListener(TimerEvent.TIMER, countdown_timerHandler);
            countdown.removeEventListener(TimerEvent.TIMER_COMPLETE, countdown_timerCompleteHandler)
            countdown = null;
            counter_lbl.text = "";
        }

        private function m_ten_clickHandler(event: MouseEvent): void
        {
            totalScore -= 10;
            scoreProgress.postScore(totalScore);
        }

        private function p_ten_clickHandler(event: MouseEvent): void
        {
            totalScore += 10;
            scoreProgress.postScore(totalScore);
        }

        private function resizeHandler(event: ResizeEvent): void
        {
            place.width = stage.stageWidth;
        }
    }
}
