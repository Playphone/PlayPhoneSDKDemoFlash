package hcode.veconomy
{
    import flash.events.Event;

    import mx.events.FlexEvent;

    import spark.components.List;
    import spark.components.TabBar;

    import spark.components.VGroup;

    import com.playphone.multinet.MNDirect
    import com.playphone.multinet.MNDirectEvent
    import com.playphone.multinet.providers.MNVitemsProvider

    import mx.collections.ArrayList
    import mx.events.FlexEvent

    import spark.events.IndexChangeEvent

    public class VItems extends VGroup
    {
        private var isSessionReady: Boolean = false;
        private var updateFunctions: Vector.<Function>;
        private var currentStateIndex: int = -1;
        private var tab_contens: Array;

        public var currencies_list:List;
        public var items_list:List;

        public var tabs:TabBar;

        public function VItems()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(event: FlexEvent): void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            updateFunctions = new Vector.<Function>();
            updateFunctions.push(updateItems);
            updateFunctions.push(updateCurrencies);

            tab_contens = [];
            tab_contens.push(items_list);
            tab_contens.push(currencies_list);

            if (MNDirect.getSession() == null)
            {
                MNDirect.addEventListener(MNDirectEvent.onDirectSessionReady, onSessionReady);
            }
            else
            {
                onSessionReady(null);
            }

            tabs.addEventListener( IndexChangeEvent.CHANGE, tabs_changeHandler );
            showState(tabs.selectedIndex);
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

        private function updateItems(): void
        {
            var currencies: Array = [];

            var items: Array = MNDirect.virtualItemsProvider.getGameVItemsList();
            for each(var item: Object in items)
            {
                if ((item.model & 1) == 0)
                {
                    currencies.push(item);
                }
            }

            items_list.dataProvider = new ArrayList(currencies);
        }

        private function updateCurrencies(): void
        {
            var currencies: Array = [];

            var items: Array = MNDirect.virtualItemsProvider.getGameVItemsList();
            for each(var item: Object in items)
            {
                if ((item.model & 1) != 0)
                {
                    currencies.push(item);
                }
            }

            currencies_list.dataProvider = new ArrayList(currencies);

        }

        private function tabs_changeHandler(event: IndexChangeEvent): void
        {
            if (isSessionReady)
            {
                showState(event.newIndex);
                updateState(event.newIndex);
            }
        }

        private function onSessionReady(event: MNDirectEvent): void
        {
            if (MNDirect.virtualShopProvider.isVShopInfoNeedUpdate())
            {
                MNDirect.virtualItemsProvider.addEventListener(MNVitemsProvider.onVItemsListUpdated, onInfoUpdated);
                MNDirect.virtualItemsProvider.doGameVItemsListUpdate();
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
    }
}
