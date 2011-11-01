package hcode.veconomy
{
    import flash.events.Event;
    import flash.events.MouseEvent;

    import spark.components.Button;
    import spark.components.List;
    import spark.components.TabBar;
    import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.MNDirectHelper
    import com.playphone.multinet.providers.MNPluginEvent
    import com.playphone.multinet.providers.MNVShopProvider

    import mx.collections.ArrayList
    import mx.events.FlexEvent

    import spark.events.IndexChangeEvent

    import views.controls.DropDown;


    public class PPStore extends VGroup
    {
        private var isSessionReady: Boolean = false;
        private var updateFunctions: Vector.<Function>
        private var currentStateIndex:int = -1;
        private var tab_contens:Array;

        public var tabs: TabBar;

        public var categories_list: List;
        public var packs_list: List;
        public var buy_group: VGroup;

        public var buy: Button;
        public var vspacks: DropDown;

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
            tab_contens.push(categories_list);
            tab_contens.push(packs_list);

            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.onDirectSessionReady, onSessionReady);
            }
            else
            {
                onSessionReady(null);
            }

            tabs.addEventListener(IndexChangeEvent.CHANGE, tabBar1_changeHandler);
            buy.addEventListener(MouseEvent.CLICK, button1_clickHandler);

            showState(0);
        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            MNDirect.virtualShopProvider.addEventListener(MNVShopProvider.showDashboard, onShowDashboard);
            MNDirect.virtualShopProvider.addEventListener(MNVShopProvider.hideDashboard, onHideDashboard);
            MNDirect.virtualShopProvider.addEventListener(MNVShopProvider.transactionSuccess, onTransactionComplete);
            MNDirect.virtualShopProvider.addEventListener(MNVShopProvider.transactionFailed, onTransactionError);

            if (MNDirect.virtualShopProvider.isVShopInfoNeedUpdate())
            {
                MNDirect.virtualShopProvider.addEventListener(MNVShopProvider.packListUpdated, onInfoUpdated);
                MNDirect.virtualShopProvider.doVShopInfoUpdate();
            }
            else
            {
                isSessionReady = true;
                updateState(0);
            }
        }

        private function onInfoUpdated(event: Event): void
        {
            isSessionReady = true;
            updateState(0);
        }

        private function showState(index: int): void
        {
            if( currentStateIndex != -1 )
            {
                removeElement( tab_contens[currentStateIndex] );
            }
            else
            {
                for( var i:int=0; i< tab_contens.length; i++ )
                {
                    removeElement( tab_contens[i] );
                }
            }
            currentStateIndex = index;
            addElement( tab_contens[index] );
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
            var packs: Array = MNDirect.virtualShopProvider.getVShopPackList();
            var combo_items: Array = [];
            for each(var pack: Object in packs)
            {
                combo_items.push({label:pack.name + " ( " + "$" + (pack.priceValue / 100).toString() + ")", data:pack});
            }
            vspacks.dataProvider = new ArrayList(combo_items);
            vspacks.selectedIndex = 0;
        }

        private function updatePacksScreen(): void
        {
            var packs: Array = MNDirect.virtualShopProvider.getVShopPackList();
            packs_list.dataProvider = new ArrayList(packs);
        }

        private function updateCategories(): void
        {
            categories_list.dataProvider = new ArrayList(MNDirect.virtualShopProvider.getVShopCategoryList());
        }

        private function tabBar1_changeHandler(event: IndexChangeEvent): void
        {
            if (isSessionReady)
            {
                showState(event.newIndex);
                updateState(event.newIndex);
            }
        }

        private function button1_clickHandler(event: MouseEvent): void
        {
            var obj: Object = vspacks.dataProvider.getItemAt(vspacks.selectedIndex);

            MNDirect.virtualShopProvider.execCheckoutVShopPacks([obj.data.id], [1],
                                                                MNDirect.virtualItemsProvider.getNewClientTransactionId());
        }

        private function onShowDashboard(event: Event): void
        {
            MNDirectHelper.showDashboard();
        }

        private function onHideDashboard(event: Event): void
        {
            MNDirectHelper.hideDashboard()
        }

        private function onTransactionComplete(event: MNPluginEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this, "Pack( id= " + event.params.items_to_add[0] + " ) succsessfully bought");
        }

        private function onTransactionError(event: MNPluginEvent): void
        {
            PlayPhoneSDKDemoFlash.showMessage(this, "Errort occurred due buying pack code: " +
                                                    event.params.error_code + " " + event.params.error_message);
        }
    }
}
