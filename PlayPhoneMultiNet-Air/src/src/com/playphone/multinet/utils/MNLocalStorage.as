package com.playphone.multinet.utils
{
    import com.playphone.multinet.MNVarStorage;

    import flash.events.NetStatusEvent
    import flash.net.SharedObject
    import flash.net.SharedObjectFlushStatus
    import flash.utils.Dictionary

    public class MNLocalStorage
    {
        private static const STORAGE_NAME: String = "MultinetUsersStorage";
        private static const TMP_PREFIX: String = "tmp.";
        private static const PROP_PREFIX: String = "prop.";

        public static const DM: String = ";";

        private static var inst: MNLocalStorage = null;

        private var data: Dictionary;//{name:var_name, val:value}
        private var tmpData: Dictionary;//{name:var_name, val:value}

        public function MNLocalStorage()
        {
            var mySo: SharedObject = SharedObject.getLocal(STORAGE_NAME);
            data = parseData(mySo.data.savedValue as String);

            if (data == null)
            {
                data = new Dictionary();
            }

            tmpData = new Dictionary();
        }

        public static function resaveCred():void
        {
            inst = new MNLocalStorage();
            var data: Array = inst.getVariablesByMask("cred.*");
            var procArr: Array = [];
            for each(var cred:* in data)
            {
                var params:Array = cred.val.split(DM);
                procArr.push({userId:int(params[2]), userName:params[3], userAuthSign:params[1]});
            }

            MNVarStorage.resave(procArr);
        }


        private function setVar(var_name: String, value: String): void
        {
            if (stringHasTempPrefix(var_name))
            {
                tmpData[var_name] = {name:var_name, val:value};
            }
            else
            {
                data[var_name] = {name:var_name, val:value};
                save();
            }
        }

        private function getVar(var_name: String): String
        {
            if (data.hasOwnProperty(var_name))
            {
                return data[var_name].val;
            }
            else if (tmpData.hasOwnProperty(var_name))
            {
                return tmpData[var_name].val;
            }
            else
            {
                return null;
            }
        }

        private function removeVar(var_name: String): void
        {
            if (data.hasOwnProperty(var_name))
            {
                delete data[var_name];
                save();
            }

            if (tmpData.hasOwnProperty(var_name))
            {
                delete tmpData[var_name];
            }
        }

        private function getVariablesByMask(mask: String): Array
        {
            var prefix: String = getMaskPrefix(mask);
            var ret: Array = new Array();
            if (prefix != null)
            {

                for each(var item: Object in data)
                {

                    if ((item.name as String).indexOf(prefix) == 0)
                    {
                        ret.push(item);
                    }
                }

                for each(var item1: Object in tmpData)
                {
                    if ((item1.name as String).indexOf(prefix) == 0)
                    {
                        ret.push(item);
                    }
                }
            }
            else
            {
                if (data[mask] != null)
                {
                    ret.push(data[mask]);
                }

                if (tmpData[mask] != null)
                {
                    ret.push(tmpData[mask]);
                }
            }

            return ret;
        }

        private function getVariablesByMasks(masks: Array): Array
        {
            var retArr: Array = new Array();
            for each(var mask: String in masks)
            {
                retArr = retArr.concat(getVariablesByMask(mask));
            }

            return retArr;
        }

        private function removeVariablesByMask(mask: String): void
        {
            var prefix: String = getMaskPrefix(mask);
            var isNotTempRemoved: Boolean = false;
            if (prefix != null)
            {
                for each(var item: Object in data)
                {
                    if ((item.name as String).indexOf(prefix) == 0)
                    {
                        delete data[item.name];
                        isNotTempRemoved = true;
                    }
                }

                for each(var item1: Object in tmpData)
                {
                    if ((item1.name as String).indexOf(prefix) == 0)
                    {
                        delete tmpData[item1.name];
                        isNotTempRemoved = true;
                    }
                }
            }
            else
            {
                if (data[mask] != null)
                {
                    delete data[mask];
                    isNotTempRemoved = true;
                }

                if (tmpData[mask] != null)
                {
                    delete tmpData[mask];
                }
            }

            if (isNotTempRemoved)
            {
                save();
            }
        }

        private function removeVariablesByMasks(masks: Array): void
        {
            for each(var mask: String in masks)
            {
                removeVariablesByMask(mask);
            }
        }

        private function save(): void
        {
            var mySo: SharedObject = SharedObject.getLocal(STORAGE_NAME);
            mySo.data.savedValue = getSerializedData(data);

            var flushStatus: String = null;
            try
            {
                flushStatus = mySo.flush(10000);
            }
            catch (error: Error)
            {
                trace("Error...Could not write SharedObject to disk");//error
            }

            if (flushStatus != null)
            {
                if (flushStatus == SharedObjectFlushStatus.PENDING)
                {
                    trace("Requesting permission to save object...");
                    mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                }
            }
        }

        private function onFlushStatus(event: NetStatusEvent): void
        {
            if (event.info.code)
            {
                trace("Error. Value didn`t flushed to disk.");//error
            }
        }

        private static function getMaskPrefix(mask: String): String
        {
            if (mask.charAt(mask.length - 1) == "*")
            {
                return mask.substring(0, mask.length - 1);
            }
            else
            {
                return null;
            }
        }

        private static function stringHasTempPrefix(str: String): Boolean
        {
            return str.indexOf(TMP_PREFIX) == 0 || str.indexOf(PROP_PREFIX) == 0;
        }

        private function getSerializedData(dict: Dictionary): String
        {
            var ret: String = "";
            for each(var item: Object in dict)
            {
                ret += item.name + "|" + item.val + "\r\n";
            }
            return ret.length > 0 ? ret : null;
        }

        private function parseData(strDate: String): Dictionary
        {
            if (strDate != null)
            {
                var ret: Dictionary = new Dictionary();
                var arrDate: Array = strDate.split("\r\n");
                for each(var itm: String in arrDate)
                {
                    var params: Array = itm.split("|");
                    ret[params[0]] = {name:params[0], val:params[1]};
                }
                return ret;
            }
            return null;
        }
    }
}
