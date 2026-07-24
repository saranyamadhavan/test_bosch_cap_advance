sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"bosch/manageorders/test/integration/pages/PurchaseOrderSetList.gen",
	"bosch/manageorders/test/integration/pages/PurchaseOrderSetObjectPage.gen",
	"bosch/manageorders/test/integration/pages/PurchaseItemSetObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSetListGenerated, PurchaseOrderSetObjectPageGenerated, PurchaseItemSetObjectPageGenerated) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('bosch/manageorders') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetListGenerated: PurchaseOrderSetListGenerated,
			onThePurchaseOrderSetObjectPageGenerated: PurchaseOrderSetObjectPageGenerated,
			onThePurchaseItemSetObjectPageGenerated: PurchaseItemSetObjectPageGenerated
        },
        async: true
    });

    return runner;
});

