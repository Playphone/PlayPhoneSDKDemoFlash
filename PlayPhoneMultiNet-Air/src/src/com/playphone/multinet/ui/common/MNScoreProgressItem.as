package com.playphone.multinet.ui.common
{
    import com.playphone.multinet.MNUserInfo

    import flash.display.DisplayObject
    import flash.display.MovieClip
    import flash.text.TextField
    import flash.text.TextFormat

    public class MNScoreProgressItem
    {
        private var content: MovieClip;

        private var avatar: MNImage;

        private var place: TextField;
        private var scores: TextField;
        private var name: TextField;

        private var isFirst: Boolean = false;
        private var suffixes: Array = [
            "st", "nd", "rd", "th"];
        private var currentUserId: int = -1;
        private var currentPlace: int = -1;

        public function MNScoreProgressItem(content: DisplayObject, additionalParams: Object = null)
        {
            this.content = content as MovieClip;
            avatar = new MNImage(this.content.getChildByName("avatar"));
            place = this.content.getChildByName("place") as TextField;
            place.text = " ";
            scores = this.content.getChildByName("scores") as TextField;
            scores.text = " ";
            name = this.content.getChildByName("name_1") as TextField;
            name.text = " ";
            this.content.gotoAndStop(1);
        }

        public function updateScore(item: Object): void
        {
            //{ userInfo:userInfo, score:score, place:0 }
            if (item != null)
            {
                var usrInfo: * = item.userInfo;

                var score: int = item.score;
                scores.text = score.toString();

                var placeVal: int = item.place;
                if (placeVal != currentPlace)
                {
                    currentPlace = placeVal;
                    place.text = getPlaceString(placeVal);
                    isFirstPlace = (placeVal == 1);
                }

                if (usrInfo.userId != currentUserId)
                {
                    var text: String = usrInfo.userName;
                    var textFormat: TextFormat = name.getTextFormat();
                    name.text = unescape(text);
                    name.setTextFormat(textFormat);

                    currentUserId = usrInfo.userId;
                    //					name.text = usrInfo.userName;
                    avatar.loadImage(usrInfo.userAvatarUrl);
                }
            }
        }

        private function getPlaceString(place: int): String
        {
            var lastIndex: int = place % 10;
            var lastNumber: int = place % 100;

            if (lastIndex >= 4 || lastIndex == 0)
            {
                return place + suffixes[3];
            }
            else
            {
                if (lastNumber > 20 || lastNumber < 10)
                {
                    return place + suffixes[lastIndex - 1];
                }
                else
                {
                    return place + suffixes[3];
                }
            }
        }

        private function set isFirstPlace(val: Boolean): void
        {
            if (val != isFirst)
            {
                if (val)
                {
                    content.gotoAndStop(2);
                }
                else
                {
                    content.gotoAndStop(1);
                }
            }

            isFirst = val;
        }
    }
}
