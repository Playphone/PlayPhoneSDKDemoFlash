package hcode.veconomy
{
    import com.playphone.multinet.providers.MNVItemsProviderEvent;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.collections.ArrayCollection;

    import spark.components.Button;

    import spark.components.List;

    import spark.components.TabBar;
    import spark.components.TextInput;

    import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent

    import mx.collections.ArrayList
    import mx.events.FlexEvent

    import spark.events.IndexChangeEvent

    import views.controls.DropDown;

    public class UserItems extends VGroup
    {
        private var isSessionReady: Boolean = false;
        private var currentStateIndex: int = -1;
        private var tab_contens: Array;
        private var updateFunctions: Vector.<Function>


        public var tabs: TabBar;
        public var user_items_list: List;
        public var manager_group: VGroup;

        public var txtItemIdToAdd: TextInput;
        public var btnAdd: Button;
        public var txtItemIdToRemove: TextInput;
        public var btnRemove: Button;
        public var items: DropDown;


        public function UserItems()
        {
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            updateFunctions = new Vector.<Function>();
            updateFunctions.push(updateInventory);
            updateFunctions.push(updateManager);

            tab_contens = [];
            tab_contens.push(user_items_list);
            tab_contens.push(manager_group);

            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.mnDirectSessionReady, onSessionReady);
            }
            else
            {
                onSessionReady(null);
            }

            tabs.addEventListener(IndexChangeEvent.CHANGE, tabBar1_changeHandler);
            btnAdd.addEventListener(MouseEvent.CLICK, btnAdd_clickHandler);
            btnRemove.addEventListener(MouseEvent.CLICK, btnRemove_clickHandler);
            showState(tabs.selectedIndex);
        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            MNDirect.getVItemsProvider().addEventListener(MNVItemsProviderEvent.onVItemsTransactionCompleted, onComplete);
            MNDirect.getVItemsProvider().addEventListener(MNVItemsProviderEvent.onVItemsTransactionFailed, onFail);

            if (MNDirect.getVItemsProvider().isGameVItemsListNeedUpdate())
            {
                MNDirect.getVItemsProvider().addEventListener(MNVItemsProviderEvent.onVItemsListUpdated, onInfoUpdated);
                MNDirect.getVItemsProvider().doGameVItemsListUpdate();
            }
            else
            {
                isSessionReady = true;
                updateState(tabs.selectedIndex);
            }
        }

        private function showState(index: int): void
        {
            if (currentStateIndex != -1)
            {
                removeElement(tab_contens[currentStateIndex]);
            }
            else
            {
                for (var i: int = 0; i < tab_contens.length; i++)
                {
                    removeElement(tab_contens[i]);
                }
            }
            currentStateIndex = index;
            addElement(tab_contens[index]);
        }

        private function onInfoUpdated(event: Event): void
        {
            isSessionReady = true;
            updateState(tabs.selectedIndex);
        }

        private function updateState(state: int): void
        {
            if (isSessionReady)
            {
                updateFunctions[state]();
            }
        }

        private function updateInventory(): void
        {
            var userItems: Array = MNDirect.getVItemsProvider().getPlayerVItemList();
            user_items_list.dataProvider = new ArrayCollection(userItems);
        }

        private function updateManager(): void
        {
            var packs: Array = MNDirect.getVItemsProvider().getGameVItemsList();
            var vItems: Array = [];
            for each(var pack: Object in packs)
            {
                vItems.push({label:pack.name, data:pack});
            }

            items.dataProvider = new ArrayList(vItems);
            items.selectedIndex = 0;
        }

        private function tabBar1_changeHandler(event: IndexChangeEvent): void
        {
            if (isSessionReady)
            {
                showState(event.newIndex);
                updateState(event.newIndex);
            }
        }

        private function btnAdd_clickHandler(event: MouseEvent): void
        {
            var selectedItem: Object = items.dataProvider.getItemAt(items.selectedIndex);
            var transactionId: int = MNDirect.getVItemsProvider().getNewClientTransactionId();
            PlayPhoneSDKDemoFlash.showMessage(this,
                                              "Transaction ( id=" + transactionId + " ) started. " + txtItemIdToAdd.text + " items will be added");
            MNDirect.getVItemsProvider().reqAddPlayerVItem(selectedItem.data.id, int(txtItemIdToAdd.text), transactionId);
        }

        private function btnRemove_clickHandler(event: MouseEvent): void
        {
            var selectedItem: Object = items.dataProvider.getItemAt(items.selectedIndex);
            var transactionId: int = MNDirect.getVItemsProvider().getNewClientTransactionId();
            PlayPhoneSDKDemoFlash.showMessage(this,
                                              "Transaction ( id=" + transactionId + " ) started. " + txtItemIdToRemove.text + " items will be removed");
            MNDirect.getVItemsProvider().reqAddPlayerVItem(selectedItem.data.id, -1 * int(txtItemIdToRemove.text), transactionId);
        }

        private function onComplete(event: MNVItemsProviderEvent): void
        {
            var info: * = event.params.transaction;
            PlayPhoneSDKDemoFlash.showMessage(this, "Transaction ( id=" + info.clientTransactionId + " ) completed");
        }

        private function onFail(event: MNVItemsProviderEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this, "Transaction ( id=" + event.params.error.clientTransactionId + " ) failed. " +
                                                    event.params.error.failReasonCode + ":" + event.params.error.errorMessage);
        }
    }
}
