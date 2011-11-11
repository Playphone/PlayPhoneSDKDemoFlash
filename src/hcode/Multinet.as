package hcode
{
    import com.playphone.multinet.ui.common.MNDirectButton;

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
        public var m_ten: Button;
        public var p_ten: Button;
        public var counter_lbl: Label;
        public var tip: Label;
        public var post_score: Button;

        public function Multinet()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
            this.addEventListener(ResizeEvent.RESIZE, resizeHandler);
        }

        private function creationCompleteHandler(event: FlexEvent): void
        {
            MNSession.instance.addEventListener(MNSessionEvent.onSessionStatusChanged, onSessionStatusChangedHandler);
            MNDirect.addEventListener(MNDirectEvent.onDoFinishGame, MNDirect_onDoFinishGameHandler);
            MNDirect.addEventListener(MNDirectEvent.onDoCancelGame, MNDirect_onDoCancelGameHandler);

            m_ten.addEventListener(MouseEvent.CLICK, m_ten_clickHandler);
            p_ten.addEventListener(MouseEvent.CLICK, p_ten_clickHandler);
            post_score.addEventListener(MouseEvent.CLICK, post_score_clickHandler);

            var shape: MovieClip = new MovieClip();
            shape.graphics.beginFill(0x000000, 0);
            shape.graphics.drawRect(0, 0, stage.stageWidth, 120);
            shape.graphics.endFill();

            place.width = stage.stageWidth;
            place.addChild(shape);


            scoreProgress = new MNScoreProgressView(shape);
            onSessionStatusChangedHandler(null);
        }

        private function onSessionStatusChangedHandler(event: MNSessionEvent): void
        {
            var sessionStatus: int = MNSession.instance.getStatus();
            var userStatus: int = MNSession.instance.getRoomUserStatus();

            if ((sessionStatus == MNConst.MN_OFFLINE) || (sessionStatus == MNConst.MN_CONNECTING))
            {
                tip.text = "Player should be logged in to use Multiplayer features. Please open PlayPhone " +
                           "dashboard and login to PlayPhone network";
            }
            else if (sessionStatus == MNConst.MN_LOGGEDIN)
            {
                tip.text = "Please open PlayPhone dashboard and press PlayNow button to start Multiplater game.";
            }
            else
            {
                if (userStatus == MNConst.MN_USER_CHATER)
                {
                    tip.text = "Currently you are \"CHATTER\". Please wait for end of current game round and then press " +
                               "\"Play next round\" button on PPS Dashboard.";
                }

                if (sessionStatus == MNConst.MN_IN_GAME_WAIT)
                {
                    tip.text = "Waiting for opponents";
                }
                else if (sessionStatus == MNConst.MN_IN_GAME_START)
                {
                    tip.text = "Starting the game";
                }
                else if (sessionStatus == MNConst.MN_IN_GAME_PLAY)
                {
                    tip.text = "Use buttons to change your score. You will see the progress on the top indicator.";

                    MNDirectHelper.hideDashboard();
                    MNDirectButton.show();
                    countdown = new Timer(1000, 60);
                    counter = 60;
                    counter_lbl.text = counter.toString();
                    countdown.addEventListener(TimerEvent.TIMER, countdown_timerHandler);
                    countdown.addEventListener(TimerEvent.TIMER_COMPLETE, countdown_timerCompleteHandler)
                    countdown.start();
                }
                else if (sessionStatus == MNConst.MN_IN_GAME_END)
                {
                    tip.text = "Posting the scores.\nYou can use \"Post Score\" button to send current " +
                               "score to PPS server";
                }
                else
                {
                    tip.text = "Undefined state: SessionState: " + sessionStatus + " UserState: " + userStatus;
                }
            }
        }

        private function MNDirect_onDoFinishGameHandler(event: MNDirectEvent): void
        {
            stopTimer();
            post_score.visible = true;
            totalScore = 0;
        }

        private function MNDirect_onDoCancelGameHandler(event: MNDirectEvent): void
        {
            stopTimer();
            totalScore = 0;
        }

        private function countdown_timerHandler(event: TimerEvent): void
        {
            counter_lbl.text = counter.toString();
            counter--;
        }

        private function countdown_timerCompleteHandler(event: TimerEvent): void
        {
            stopTimer();
        }

        private function stopTimer(): void
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

        private function post_score_clickHandler(event: MouseEvent): void
        {
            MNDirect.postGameScore(totalScore);
            post_score.visible = false;
        }
    }
}
