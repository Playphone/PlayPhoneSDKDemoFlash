package hcode.veconomy
{
    import com.playphone.multinet.MNDirectUIHelper;
    import com.playphone.multinet.providers.MNVShopProviderEvent;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import spark.components.Button;
    import spark.components.List;
    import spark.components.TabBar;
    import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.providers.MNVShopProvider

    import mx.collections.ArrayList
    import mx.events.FlexEvent

    import spark.events.IndexChangeEvent

    import views.controls.DropDown;


    public class PPStore extends VGroup
    {
        private var isSessionReady: Boolean = false;
        private var updateFunctions: Vector.<Function>
        private var currentStateIndex: int = -1;
        private var tab_contens: Array;

        public var tabs: TabBar;

        public var vShopCategories_list: List;
        public var vShopPacks_list: List;
        public var buy_group: VGroup;

        public var btnBuy: Button;
        public var vShopPacks: DropDown;

        public function PPStore()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

            updateFunctions = new Vector.<Function>();
            updateFunctions.push(updateBuyScreen);
            updateFunctions.push(updateCategories);
            updateFunctions.push(updatePacksScreen);

            tab_contens = [];
            tab_contens.push(buy_group);
            tab_contens.push(vShopCategories_list);
            tab_contens.push(vShopPacks_list);

            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.mnDirectSessionReady, onSessionReady);
            }
            else
            {
                onSessionReady(null);
            }

            tabs.addEventListener(IndexChangeEvent.CHANGE, tabs_changeHandler);
            btnBuy.addEventListener(MouseEvent.CLICK, btnBuy_clickHandler);

            showState(tabs.selectedIndex);
        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            MNDirect.getVShopProvider().addEventListener(MNVShopProviderEvent.showDashboard, onShowDashboard);
            MNDirect.getVShopProvider().addEventListener(MNVShopProviderEvent.hideDashboard, onHideDashboard);
            MNDirect.getVShopProvider().addEventListener(MNVShopProviderEvent.onCheckoutVShopPackSuccess, onTransactionComplete);
            MNDirect.getVShopProvider().addEventListener(MNVShopProviderEvent.onCheckoutVShopPackFail, onTransactionError);

            if (MNDirect.getVShopProvider().isVShopInfoNeedUpdate())
            {
                MNDirect.getVShopProvider().addEventListener(MNVShopProviderEvent.onVShopInfoUpdated, onInfoUpdated);
                MNDirect.getVShopProvider().doVShopInfoUpdate();
            }
            else
            {
                isSessionReady = true;
                updateState(tabs.selectedIndex);
            }
        }

        private function onInfoUpdated(event: Event): void
        {
            isSessionReady = true;
            updateState(tabs.selectedIndex);
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

        private function updateState(state: int): void
        {
            if (isSessionReady)
            {
                updateFunctions[state]();
            }
        }

        private function updateBuyScreen(): void
        {
            var packs: Array = MNDirect.getVShopProvider().getVShopPackList() as Array;
            var combo_items: Array = [];
            for each(var pack: Object in packs)
            {
                combo_items.push({label:pack.name + " ( " + "$" + (pack.priceValue / 100).toString() + ")", data:pack});
            }
            vShopPacks.dataProvider = new ArrayList(combo_items);
            vShopPacks.selectedIndex = 0;
        }

        private function updatePacksScreen(): void
        {
            var packs: Array = MNDirect.getVShopProvider().getVShopPackList();
            vShopPacks_list.dataProvider = new ArrayList(packs);
        }

        private function updateCategories(): void
        {
            vShopCategories_list.dataProvider = new ArrayList(MNDirect.getVShopProvider().getVShopCategoryList());
        }

        private function tabs_changeHandler(event: IndexChangeEvent): void
        {
            if (isSessionReady)
            {
                showState(event.newIndex);
                updateState(event.newIndex);
            }
        }

        private function btnBuy_clickHandler(event: MouseEvent): void
        {
            var vShopPackItem: Object = vShopPacks.dataProvider.getItemAt(vShopPacks.selectedIndex);
            MNDirect.getVShopProvider().execCheckoutVShopPacks([vShopPackItem.data.id], [1],
                                                               int(MNDirect.getVItemsProvider().getNewClientTransactionId()));
        }

        private function onShowDashboard(event: Event): void
        {
            MNDirectUIHelper.showDashboard();
        }

        private function onHideDashboard(event: Event): void
        {
            MNDirectUIHelper.hideDashboard();
        }

        private function onTransactionComplete(event: MNVShopProviderEvent): void
        {
            var addedItem:* = event.params.result.transaction.vItems[0];
            PlayPhoneSDKDemoFlash.showMessage(this, "Item (id=" + addedItem.id + ") succsessfully bought. Count=" + addedItem.delta);
        }

        private function onTransactionError(event: MNVShopProviderEvent): void
        {

            PlayPhoneSDKDemoFlash.showMessage(this, "Errort occurred due buying pack code: " +
                                                    event.params.result.errorCode + " " + event.params.result.errorMessage);
        }
    }
}
