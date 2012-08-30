package com.playphone.multinet
{
    import com.playphone.air.PlayPhoneMultiNetExt;
    import com.playphone.multinet.core.MNSession;
    import com.playphone.multinet.providers.MNAchievementsProvider;
    import com.playphone.multinet.providers.MNClientRobotsProvider;
    import com.playphone.multinet.providers.MNGameCookiesProvider;
    import com.playphone.multinet.providers.MNGameRoomCookiesProvider;
    import com.playphone.multinet.providers.MNGameSettingsProvider;
    import com.playphone.multinet.providers.MNMyHiScoresProvider;
    import com.playphone.multinet.providers.MNPlayerListProvider;
    import com.playphone.multinet.providers.MNScoreProgressProvider;
    import com.playphone.multinet.providers.MNServerInfoProvider;
    import com.playphone.multinet.providers.MNVItemsProvider;
    import com.playphone.multinet.providers.MNVShopProvider;
    import com.playphone.multinet.providers.MNWSProvider;
    import com.playphone.multinet.utils.MNLocalStorage;

    public class MNDirect
    {
        public static function init(gameId:int, gameSecret:String):void
        {
            PlayPhoneMultiNetExt.initExtension();
            MNLocalStorage.resaveCred();
            MNDirectExt.init(gameId, gameSecret);
        }

        public static function makeGameSecretByComponents(secret1: uint, secret2: uint, secret3: uint, secret4: uint): String
        {
            return secret1.toString(16) + "-" + secret2.toString(16) + "-" + secret3.toString(16) + "-" + secret4.toString(16);
        }

        public static function shutdownSession():void
        {
            MNDirectExt.shutdownSession();
        }
        public static function isOnline():Boolean
        {
            return MNDirectExt.isOnline();
        }
        public static function isUserLoggedIn():Boolean
        {
            return MNDirectExt.isUserLoggedIn();
        }
        public static function getSessionStatus():int
        {
            return MNDirectExt.getSessionStatus();
        }
        public static function postGameScore(score:int):void
        {
            MNDirectExt.postGameScore(score);
        }
        public static function postGameScorePending(score:int):void
        {
            MNDirectExt.postGameScorePending(score);
        }
        public static function cancelGame():void
        {
            MNDirectExt.cancelGame();
        }
        public static function setDefaultGameSetId(gameSetId:int):void
        {
            MNDirectExt.setDefaultGameSetId(gameSetId);
        }
        public static function getDefaultGameSetId():int
        {
            return MNDirectExt.getDefaultGameSetId();
        }
        public static function sendAppBeacon(actionName:String, beaconData:String):void
        {
            MNDirectExt.sendAppBeacon(actionName, beaconData);
        }
        public static function execAppCommand(name:String, param:String):void
        {
            MNDirectExt.sendAppBeacon(name, param);
        }
        public static function sendGameMessage(message:String):void
        {
            MNDirectExt.sendGameMessage(message);
        }
        public static function getSession():MNSession
        {
            return MNDirectExt.getSession();
        }
        public static function getAchievementsProvider():MNAchievementsProvider
        {
            return MNDirectExt.getAchievementsProvider();
        }
        public static function getClientRobotsProvider():MNClientRobotsProvider
        {
            return MNDirectExt.getClientRobotsProvider();
        }
        public static function getGameCookiesProvider():MNGameCookiesProvider
        {
            return MNDirectExt.getGameCookiesProvider();
        }
        public static function getGameRoomCookiesProvider():MNGameRoomCookiesProvider
        {
            return MNDirectExt.getGameRoomCookiesProvider();
        }
        public static function getMyHiScoresProvider():MNMyHiScoresProvider
        {
            return MNDirectExt.getMyHiScoresProvider();
        }
        public static function getPlayerListProvider():MNPlayerListProvider
        {
            return MNDirectExt.getPlayerListProvider();
        }
        public static function getScoreProgressProvider():MNScoreProgressProvider
        {
            return MNDirectExt.getScoreProgressProvider();
        }
        public static function getVItemsProvider():MNVItemsProvider
        {
            return MNDirectExt.getVItemsProvider();
        }
        public static function getVShopProvider():MNVShopProvider
        {
            return MNDirectExt.getVShopProvider();
        }
        public static function getGameSettingsProvider():MNGameSettingsProvider
        {
            return MNDirectExt.getGameSettingsProvider();
        }
        public static function getServerInfoProvider():MNServerInfoProvider
        {
            return MNDirectExt.getServerInfoProvider();
        }
        public static function getWSProvider():MNWSProvider
        {
            return MNDirectExt.getWSProvider();
        }

        public static function addEventListener(type: String, listener: Function, useCapture: Boolean = false, priority: int = 0, useWeakReference: Boolean = false): void
        {
            MNDirectExt.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public static function removeEventListener(type: String, listener: Function, useCapture: Boolean = false): void
        {
            MNDirectExt.addEventListener(type, listener, useCapture);
        }
    }
}
