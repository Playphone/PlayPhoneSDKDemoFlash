package com.playphone.multinet.ui.common
{
    import com.playphone.multinet.MNConst
    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.MNUserInfo
    import com.playphone.multinet.core.MNSession
    import com.playphone.multinet.core.MNSessionEvent
    import com.playphone.multinet.providers.MNScoreProgressProvider
    import com.playphone.multinet.providers.MNScoreProgressProviderEvent;

    import flash.display.DisplayObjectContainer
    import flash.display.MovieClip

    public class MNScoreProgressView
    {
        private var content: MovieClip;
        private var parent: DisplayObjectContainer;
        private var item_1: MNScoreProgressItem;
        private var item_2: MNScoreProgressItem;

        public function MNScoreProgressView(parent: DisplayObjectContainer)
        {
            this.parent = parent;

            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.mnDirectSessionReady, onDirectReady);
            }
            else
            {
                MNDirect.getSession().addEventListener(MNSessionEvent.mnSessionStatusChanged, onStatusChanged);
                onStatusChanged(null);
            }
        }

        private function onDirectReady(evt: MNDirectEvent): void
        {
            MNDirect.removeEventListener(MNDirectEvent.mnDirectSessionReady, onDirectReady);
            MNDirect.getSession().addEventListener(MNSessionEvent.mnSessionStatusChanged, onStatusChanged);
        }

        private function onStatusChanged(evt: MNSessionEvent): void
        {
            var sessionStatus: int = MNDirect.getSession().getStatus();
            if (sessionStatus == MNConst.MN_IN_GAME_PLAY)
            {
//                MNDirect.getScoreProgressProvider().setRefreshIntervalAndUpdateDelay(-1, -1);
                MNDirect.getScoreProgressProvider().start();
                MNDirect.getScoreProgressProvider().postScore(0);
                show();
            }
            else
            {
                MNDirect.getScoreProgressProvider().stop();
                hide();
            }
        }

        public function postScore(score: int): void
        {
            MNDirect.getScoreProgressProvider().postScore(score);
        }

        public function show(): void
        {
            var newPPV: ProgressPanelView = new ProgressPanelView();
            newPPV.scaleX = parent.width / newPPV.width;
            newPPV.scaleY = parent.height / newPPV.height;

            content = parent.addChild(newPPV) as MovieClip;
            item_1 = new MNScoreProgressItem(content.getChildByName("item_1"));
            item_2 = new MNScoreProgressItem(content.getChildByName("item_2"));
            MNDirect.getScoreProgressProvider().addEventListener(MNScoreProgressProviderEvent.onScoresUpdated, onScoresUpdate);
        }

        public function hide(): void
        {
            MNDirect.getScoreProgressProvider().removeEventListener(MNScoreProgressProviderEvent.onScoresUpdated, onScoresUpdate);
            if (content != null)
            {
                if (parent.contains(content))
                {
                    parent.removeChild(content);
                }
            }
        }

        public function Destroy(): void
        {
            hide();
        }

        private function onScoresUpdate(evt: MNScoreProgressProviderEvent): void
        {
            var scores: Array = evt.params.scoreBoard as Array;
            item_1.updateScore(getMyScore(scores));
            item_2.updateScore(getBestOpponent(scores));
        }

        private function getMyScore(scores: Array): Object
        {
            for each(var score: Object in scores)
            {
                var info:* = score.userInfo;
                if (info.userId == MNDirect.getSession().getMyUserId())
                {
                    return score;
                }
            }
            return null;
        }

        private function getBestOpponent(scores: Array): Object
        {
            var minPlace: int = int.MAX_VALUE;
            var ret: Object = null;
            for each(var score: Object in scores)
            {
                var info: * = score.userInfo;
                if (info.userId != MNDirect.getSession().getMyUserId())
                {
                    if (score.place < minPlace)
                    {
                        minPlace = score.place;
                        ret = score;
                    }
                }
            }
            return ret;
        }
    }
}