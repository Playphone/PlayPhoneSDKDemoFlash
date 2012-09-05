package hcode
{
import com.playphone.multinet.core.data.MNWSAnyGameItem;
import com.playphone.multinet.core.data.MNWSAnyUserItem;
import com.playphone.multinet.core.data.MNWSCurrUserSubscriptionStatus;
import com.playphone.multinet.core.data.MNWSCurrentUserInfo;
import com.playphone.multinet.core.data.MNWSLeaderboardListItem;
import com.playphone.multinet.core.data.MNWSSessionSignedClientToken;
import com.playphone.multinet.core.data.MNWSSystemGameNetStats;
import com.playphone.multinet.providers.requests.LeaderboardModeAnyGameGlobal;
import com.playphone.multinet.providers.requests.LeaderboardModeCurrUserAnyGameLocal;
import com.playphone.multinet.providers.requests.LeaderboardModeCurrentUser;
import com.playphone.multinet.providers.requests.MNWSInfoRequestAnyGame;
import com.playphone.multinet.providers.requests.MNWSInfoRequestAnyUser;
import com.playphone.multinet.providers.requests.MNWSInfoRequestAnyUserGameCookies;
import com.playphone.multinet.providers.requests.MNWSInfoRequestCurrGameRoomList;
import com.playphone.multinet.providers.requests.MNWSInfoRequestCurrGameRoomUserList;
import com.playphone.multinet.providers.requests.MNWSInfoRequestCurrUserBuddyList;
import com.playphone.multinet.providers.requests.MNWSInfoRequestCurrUserSubscriptionStatus;
import com.playphone.multinet.providers.requests.MNWSInfoRequestCurrentUserInfo;
import com.playphone.multinet.providers.requests.MNWSInfoRequestLeaderboard;
import com.playphone.multinet.providers.requests.MNWSInfoRequestSessionSignedClientToken;
import com.playphone.multinet.providers.requests.MNWSInfoRequestSystemGameNetStats;
import com.playphone.multinet.providers.results.AnyGameRequestResult;
import com.playphone.multinet.providers.results.AnyUserGameCookiesRequestResult;
import com.playphone.multinet.providers.results.AnyUserRequestResult;
import com.playphone.multinet.providers.results.CurrGameRoomListRequestResult;
import com.playphone.multinet.providers.results.CurrGameRoomUserListRequestResult;
import com.playphone.multinet.providers.results.CurrUserBuddyListResponseResult;
import com.playphone.multinet.providers.results.CurrUserSubscriptionStatusRequestResult;
import com.playphone.multinet.providers.results.CurrentUserInfoRequestResult;
import com.playphone.multinet.providers.results.LeaderboardRequestResult;
import com.playphone.multinet.providers.results.RequestResult;
import com.playphone.multinet.providers.results.SessionSignedClientTokenRequestResult;
import com.playphone.multinet.providers.results.SystemGameNetStatsRequestResult;

import flash.events.MouseEvent;

import mx.collections.ArrayList;

import spark.components.Button;
import spark.components.Label;
import spark.components.List;

import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent

    import mx.events.FlexEvent

    public class WSTest extends VGroup
    {
        public var MNWSAnyGame: Button;
        public var MNWSAnyUser: Button;
        public var MNWSSessionAnyUserGameCookies: Button;
        public var MNWSCurrentUserInfo: Button;
        public var MNWSCurrentGameRoomList: Button;
        public var MNWSCurrentGameRoomUserList: Button;
        public var MNWSCurrentUserBuddyList: Button;
        public var MNWSCurrUserSubscriptionStatus: Button;
        public var MNWSSessionSignedClientToken: Button;
        public var MNWSSystemNetStat: Button;

        public var MNWSLeaderboardModeCurrentUser: Button;
        public var MNWSLeaderboardModeCurrUserAnyGameLocal: Button;
        public var MNWSLeaderboardModeCurrUserAnyGameGlobal: Button;
        public var MNWSLeaderboardModeAnyGameGlobal: Button;

        public var dataLabel: Label;

        public function WSTest()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            this.addEventListener(FlexEvent.INITIALIZE, initializeHandler );
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            MNWSAnyGame.addEventListener(MouseEvent.CLICK, MNWSAnyGameClickHandler);
            MNWSAnyUser.addEventListener(MouseEvent.CLICK, MNWSAnyUserClickHandler);
            MNWSSessionAnyUserGameCookies.addEventListener(MouseEvent.CLICK, MNWSSessionAnyUserGameCookiesClickHandler);
            MNWSCurrentUserInfo.addEventListener(MouseEvent.CLICK, MNWSCurrentUserInfoClickHandler);
            MNWSCurrentGameRoomList.addEventListener(MouseEvent.CLICK, MNWSCurrentGameRoomListClickHandler);
            MNWSCurrentGameRoomUserList.addEventListener(MouseEvent.CLICK, MNWSCurrentGameRoomUserListClickHandler);
            MNWSCurrentUserBuddyList.addEventListener(MouseEvent.CLICK, MNWSCurrentUserBuddyListClickHandler);
            MNWSCurrUserSubscriptionStatus.addEventListener(MouseEvent.CLICK, MNWSCurrUserSubscriptionStatusClickHandler);
            MNWSSessionSignedClientToken.addEventListener(MouseEvent.CLICK, MNWSSessionSignedClientTokenClickHandler);
            MNWSSystemNetStat.addEventListener(MouseEvent.CLICK, MNWSSystemNetStatClickHandler);

            MNWSLeaderboardModeCurrentUser.addEventListener(MouseEvent.CLICK, LeaderboardModeCurrentUserClickHandler);
            MNWSLeaderboardModeCurrUserAnyGameLocal.addEventListener(MouseEvent.CLICK, LeaderboardModeCurrUserAnyGameLocalClickHandler);
            MNWSLeaderboardModeCurrUserAnyGameGlobal.addEventListener(MouseEvent.CLICK, LeaderboardModeCurrUserAnyGameGlobalClickHandler);
            MNWSLeaderboardModeAnyGameGlobal.addEventListener(MouseEvent.CLICK, LeaderboardModeAnyGameGlobalClickHandler);
        }

        private function initializeHandler(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.INITIALIZE, initializeHandler );
            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.mnDirectSessionReady, onSessionReady);
            }
            else
            {
                onSessionReady(null);
            }
        }

        private function onSessionReady(event: MNDirectEvent): void
        {

        }

        private function MNWSAnyGameClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestAnyGame = new MNWSInfoRequestAnyGame(MNDirect.getSession().getGameId());
            request.addEventListener(RequestResult.REPLY, onCompleteAnyGameRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSAnyUserClickHandler(event: MouseEvent): void
        {
             var request: MNWSInfoRequestAnyUser = new MNWSInfoRequestAnyUser(MNDirect.getSession().getMyUserId());
             request.addEventListener(RequestResult.REPLY, onCompleteAnyUserRequestResult);
             MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSSessionAnyUserGameCookiesClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestAnyUserGameCookies = new MNWSInfoRequestAnyUserGameCookies([MNDirect.getSession().getMyUserId()],[0]);
            request.addEventListener(RequestResult.REPLY, onCompleteAnyUserGameCoockiesRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSCurrentUserInfoClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestCurrentUserInfo = new MNWSInfoRequestCurrentUserInfo();
            request.addEventListener(RequestResult.REPLY, onCompleteCurrUserInfoRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSCurrentGameRoomListClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestCurrGameRoomList = new MNWSInfoRequestCurrGameRoomList();
            request.addEventListener(RequestResult.REPLY, onCompleteCurrGameRoomListRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSCurrentGameRoomUserListClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestCurrGameRoomUserList = new MNWSInfoRequestCurrGameRoomUserList(MNDirect.getSession().getCurrentRoomId());
            request.addEventListener(RequestResult.REPLY, onCompleteCurrGameRoomUserListRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSCurrentUserBuddyListClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestCurrUserBuddyList = new MNWSInfoRequestCurrUserBuddyList();
            request.addEventListener(RequestResult.REPLY, onCompleteCurrUserBuddyListRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSCurrUserSubscriptionStatusClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestCurrUserSubscriptionStatus = new MNWSInfoRequestCurrUserSubscriptionStatus();
            request.addEventListener(RequestResult.REPLY, onCompleteCurrUserSubscriptionStatusRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSSessionSignedClientTokenClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestSessionSignedClientToken = new MNWSInfoRequestSessionSignedClientToken("asd");
            request.addEventListener(RequestResult.REPLY, onCompleteSessionSignedClientTokenRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function MNWSSystemNetStatClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestSystemGameNetStats = new MNWSInfoRequestSystemGameNetStats();
            request.addEventListener(RequestResult.REPLY, onCompleteSystemGameNetStatsRequestResult);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function LeaderboardModeCurrentUserClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestLeaderboard =
                    new MNWSInfoRequestLeaderboard
                            (new LeaderboardModeCurrentUser(0,3));
            request.addEventListener(RequestResult.REPLY, onCompleteLeaderboard);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function LeaderboardModeCurrUserAnyGameLocalClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestLeaderboard =
                    new MNWSInfoRequestLeaderboard
                            (new LeaderboardModeCurrUserAnyGameLocal(10900,0,3));
            request.addEventListener(RequestResult.REPLY, onCompleteLeaderboard);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function LeaderboardModeCurrUserAnyGameGlobalClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestLeaderboard =
                    new MNWSInfoRequestLeaderboard
                            (new LeaderboardModeAnyGameGlobal(10900,0,3));
            request.addEventListener(RequestResult.REPLY, onCompleteLeaderboard);
            MNDirect.getWSProvider().sendSingle(request);
        }

        private function LeaderboardModeAnyGameGlobalClickHandler(event: MouseEvent): void
        {
            var request: MNWSInfoRequestLeaderboard =
                    new MNWSInfoRequestLeaderboard
                            (new LeaderboardModeAnyGameGlobal(10900,0,3));
            request.addEventListener(RequestResult.REPLY, onCompleteLeaderboard);
            MNDirect.getWSProvider().sendSingle(request);
        }

//-------------------------------------------- RequestResults-------------------------------

        private function onCompleteAnyGameRequestResult(event: AnyGameRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                             "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                             "'; \n data entry '" + ((event.getDataEntry() == null)? "null": anyGameItemTOStr(event.getDataEntry())) + "'";
        }

        private function anyGameItemTOStr(v: MNWSAnyGameItem): String
        {
            var ret: String = "";
            ret += "[ ";
            ret += "userAvatarExists =" + v.developerId;
            ret += "; ";
            ret += "userAvatarHasCustomImg =" + v.gameDesc;
            ret += "; ";
            ret += "userAvatarHasExternalUrl =" + v.gameFlags;
            ret += "; ";
            ret += "userAvatarUrl =" + v.gameGenreId;
            ret += "; ";
            ret += "userEmail =" + v.gameIconUrl;
            ret += "; ";
            ret += "userGamePoints =" + v.gameId;
            ret += "; ";
            ret += "userId =" + v.gameName;
            ret += "; ";
            ret += "userId =" + v.gamePlayModel;
            ret += "; ";
            ret += "userId =" + v.gameStatus;
            ret += "]";
            return ret;
        }

        private function onCompleteAnyUserRequestResult(event: AnyUserRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": anyUserItemTOStr(event.getDataEntry())) + "'";
        }

        private function anyUserItemTOStr(v: MNWSAnyUserItem): String
        {
            var ret: String = "";
            ret += "[ ";
            ret += "myFriendLinkStatus =" + v.myFriendLinkStatus;
            ret += "; ";
            ret += "userAvatarExists =" + v.userAvatarExists;
            ret += "; ";
            ret += "userAvatarUrl =" + v.userAvatarUrl;
            ret += "; ";
            ret += "userGamePoints =" + v.userGamePoints;
            ret += "; ";
            ret += "userId =" + v.userId;
            ret += "; ";
            ret += "userNickName =" + v.userNickName;
            ret += "; ";
            ret += "userOnlineNow =" + v.userOnlineNow;
            ret += "]";
            return ret;
        }

        private function onCompleteAnyUserGameCoockiesRequestResult(event: AnyUserGameCookiesRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": userGameCookieTOStr(event.getDataEntry())) + "'";
        }

        private function userGameCookieTOStr(v: Vector.<com.playphone.multinet.core.data.MNWSUserGameCookie>): String
        {
            var len: int = v.length;
            var ret: String = "";
            for (var i: int = 0; i < len; ++i)
            {
                ret += "[ ";
                ret += "gameId =" + v[i].cookieKey;
                ret += "; ";
                ret += "gameSetId =" + v[i].cookieValue;
                ret += "; ";
                ret += "roomIsLobby =" + v[i].userId;
                ret += "]";
            }
            return ret;
        }

        private function onCompleteCurrUserInfoRequestResult(event: CurrentUserInfoRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": currentUserInfoTOStr(event.getDataEntry())) + "'";
        }

        private function currentUserInfoTOStr(v: com.playphone.multinet.core.data.MNWSCurrentUserInfo): String
        {
            var ret: String = "";
            ret += "[ ";
            ret += "userAvatarExists =" + v.userAvatarExists;
            ret += "; ";
            ret += "userAvatarHasCustomImg =" + v.userAvatarHasCustomImg;
            ret += "; ";
            ret += "userAvatarHasExternalUrl =" + v.userAvatarHasExternalUrl;
            ret += "; ";
            ret += "userAvatarUrl =" + v.userAvatarUrl;
            ret += "; ";
            ret += "userEmail =" + v.userEmail;
            ret += "; ";
            ret += "userGamePoints =" + v.userGamePoints;
            ret += "; ";
            ret += "userId =" + v.userId;
            ret += "; ";
            ret += "userNickName =" + v.userNickName;
            ret += "; ";
            ret += "userOnlineNow =" + v.userOnlineNow;
            ret += "; ";
            ret += "userStatus =" + v.userStatus;
            ret += "]";
            return ret;
        }

        private function onCompleteCurrGameRoomListRequestResult(event: CurrGameRoomListRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": roomListItemTOStr(event.getDataEntry())) + "'";
        }

        private function roomListItemTOStr(v: Vector.<com.playphone.multinet.core.data.MNWSRoomListItem>): String
        {
            var len: int = v.length;
            var ret: String = "";
            for (var i: int = 0; i < len; ++i)
            {
                ret += "[ ";
                ret += "gameId =" + v[i].gameId;
                ret += "; ";
                ret += "gameSetId =" + v[i].gameSetId;
                ret += "; ";
                ret += "roomIsLobby =" + v[i].roomIsLobby;
                ret += "; ";
                ret += "roomName =" + v[i].roomName;
                ret += "; ";
                ret += "roomSFId =" + v[i].roomSFId;
                ret += "; ";
                ret += "roomUserCount =" + v[i].roomUserCount;
                ret += "]";
            }
            return ret;
        }

        private function onCompleteCurrGameRoomUserListRequestResult(event: CurrGameRoomUserListRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": roomUserInfoItemTOStr(event.getDataEntry())) + "'";
        }

        private function roomUserInfoItemTOStr(v: Vector.<com.playphone.multinet.core.data.MNWSRoomUserInfoItem>): String
        {
            var len: int = v.length;
            var ret: String = "";
            for (var i: int = 0; i < len; ++i)
            {
                ret += "[ ";
                ret += "roomSFId =" + v[i].roomSFId;
                ret += "; ";
                ret += "userAvatarExists =" + v[i].userAvatarExists;
                ret += "; ";
                ret += "userAvatarUrl =" + v[i].userAvatarUrl;
                ret += "; ";
                ret += "userId =" + v[i].userId;
                ret += "; ";
                ret += "userNickName =" + v[i].userNickName;
                ret += "; ";
                ret += "userOnlineNow =" + v[i].userOnlineNow;
                ret += "]";
            }
            return ret;
        }

        private function onCompleteCurrUserBuddyListRequestResult(event: CurrUserBuddyListResponseResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": buddyListItemTOStr(event.getDataEntry())) + "'";
        }

        private function buddyListItemTOStr(v: Vector.<com.playphone.multinet.core.data.MNWSBuddyListItem>): String
        {
            var len: int = v.length;
            var ret: String = "";
            for (var i: int = 0; i < len; ++i)
            {
                ret += "[ ";
                ret += "friendCurrGameAchievementsList =" + v[i].friendCurrGameAchievementsList;
                ret += "; ";
                ret += "friendFlags =" + v[i].friendFlags;
                ret += "; ";
                ret += "friendHasCurrentGame =" + v[i].friendHasCurrentGame;
                ret += "; ";
                ret += "friendInGameIconUrl =" + v[i].friendInGameIconUrl;
                ret += "; ";
                ret += "friendInGameId =" + v[i].friendInGameId;
                ret += "; ";
                ret += "friendInGameName =" + v[i].friendInGameName;
                ret += "; ";
                ret += "friendInRoomIsLobby =" + v[i].friendInRoomIsLobby;
                ret += "; ";
                ret += "friendInRoomSfid =" + v[i].friendInRoomSfid;
                ret += "; ";
                ret += "friendIsIgnored =" + v[i].friendIsIgnored;
                ret += "; ";
                ret += "friendSnId =" + v[i].friendSnId;
                ret += "; ";
                ret += "friendSnIdList =" + v[i].friendSnIdList;
                ret += "; ";
                ret += "friendSnUserAsnId =" + v[i].friendSnUserAsnId;
                ret += "; ";
                ret += "friendSnUserAsnidList =" + v[i].friendSnUserAsnidList;
                ret += "; ";
                ret += "friendUserAvatarUrl =" + v[i].friendUserAvatarUrl;
                ret += "; ";
                ret += "friendUserId =" + v[i].friendUserId;
                ret += "; ";
                ret += "friendUserLocale =" + v[i].friendUserLocale;
                ret += "; ";
                ret += "friendUserNickName =" + v[i].friendUserNickName;
                ret += "; ";
                ret += "friendUserOnlineNow =" + v[i].friendUserOnlineNow;
                ret += "; ";
                ret += "friendUserSfid =" + v[i].friendUserSfid;
                ret += "]";
            }
            return ret;
        }

        private function onCompleteCurrUserSubscriptionStatusRequestResult(event: CurrUserSubscriptionStatusRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": currUserSubscriptionStatusTOStr(event.getDataEntry())) + "'";
        }

        private function currUserSubscriptionStatusTOStr(v: com.playphone.multinet.core.data.MNWSCurrUserSubscriptionStatus): String
        {
            var ret: String = "";
            ret += "[ ";
            ret += "hasSubscription =" + v.hasSubscription;
            ret += "; ";
            ret += "isSubscriptionAvailable =" + v.isSubscriptionAvailable;
            ret += "; ";
            ret += "offersAvailable =" + v.offersAvailable;
            ret += "]";
            return ret;
        }

        private function onCompleteSessionSignedClientTokenRequestResult(event: SessionSignedClientTokenRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": sessionSignedClientTokenTOStr(event.getDataEntry())) + "'";
        }

        private function sessionSignedClientTokenTOStr(v: com.playphone.multinet.core.data.MNWSSessionSignedClientToken): String
        {
            var ret: String = "";
            ret += "[ ";
            ret += "clientTokenBody =" + v.clientTokenBody;
            ret += "; ";
            ret += "clientTokenSign =" + v.clientTokenSign;
            ret += "]";
            return ret;
        }


        private function onCompleteSystemGameNetStatsRequestResult(event: SystemGameNetStatsRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": sysGameNetStatTOStr(event.getDataEntry())) + "'";
        }
    
        private function sysGameNetStatTOStr(v: MNWSSystemGameNetStats): String
        {
           var ret: String = "";
           ret += "[ ";
           ret += "gameOnlineRooms =" + v.gameOnlineRooms;
           ret += "; ";
           ret += "gameOnlineUsers =" + v.gameOnlineUsers;
           ret += "; ";
           ret += "servOnlineGames =" + v.servOnlineGames;
           ret += "; ";
           ret += "servOnlineRooms =" + v.servOnlineRooms;
           ret += "; ";
           ret += "servTotalGames =" + v.servTotalGames;
           ret += "; ";
           ret += "servTotalUsers =" + v.servTotalUsers;
           ret += "]";
           return ret;
        }

        private function onCompleteLeaderboard(event: LeaderboardRequestResult): void
        {
            dataLabel.text = "has error '" + event.hasError() +
                    "'; \n error message '" + ((event.getErrorMessage() == null)?"null": event.getErrorMessage()) +
                    "'; \n data entry '" + ((event.getDataEntry() == null)? "null": vectorToStrLeaderboard(event.getDataEntry())) + "'";
        }

        private function vectorToStrLeaderboard(v: Vector.<MNWSLeaderboardListItem>): String
        {
            var len: int = v.length;
            var ret: String = "";
            for (var i: int = 0; i < len; ++i)
            {
                ret += "[gameId= " + v[i].gameId;
                ret += "; ";
                ret += " gamesetId= " + v[i].gamesetId;
                ret += "; ";
                ret += " outHiDatetime= " + v[i].outHiDatetime;
                ret += "; ";
                ret += " outHiDatetimeDiff= " + v[i].outHiDatetimeDiff;
                ret += "; ";
                ret += " outHiScore= " + v[i].outHiScore;
                ret += "; ";
                ret += " outHiScoreText= " + v[i].outHiScoreText;
                ret += "; ";
                ret += " outUserPlace= " + v[i].outUserPlace;
                ret += "; ";
                ret += " userAchievemenetsList= " + v[i].userAchievemenetsList;
                ret += "; ";
                ret += " userAvatarUrl= " + v[i].userAvatarUrl;
                ret += "; ";
                ret += " userId= " + v[i].userId;
                ret += "; ";
                ret += " userIsFriend= " + v[i].userIsFriend;
                ret += "; ";
                ret += " userIsIgnored= " + v[i].userIsIgnored;
                ret += "; ";
                ret += " userLocale= " + v[i].userLocale;
                ret += "; ";
                ret += " userNickName= " + v[i].userNickName;
                ret += "; ";
                ret += " userOnlineNow= " + v[i].userOnlineNow;
                ret += "; ";
                ret += " userSfid= " + v[i].userSfid + "]";
            }
            return ret;
        }
    }
}
