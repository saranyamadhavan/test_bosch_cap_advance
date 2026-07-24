namespace anunbhav.cds;


using { anubhav.db.master, anubhav.db.transaction } from './datamodel';


context CDSView {
   
    define view![POWorklist] as
        select from transaction.purchaseorder{
            key PO_ID  as![PurchaseOrderId],
            key Items.PO_ITEM_POS as![ItemPosition],
            PARTNER_GUID.BP_ID as![BusinessPartnerId],
            PARTNER_GUID.COMPANY_NAME as![BusinessPartnerName],
            PARTNER_GUID.ADDRESS_GUID.CITY as![City],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as![Country],
            GROSS_AMOUNT as![GrossAmount],
            TAX_AMOUNT as![TaxAmount],
            NET_AMOUNT as![NetAmount],
            CURRENCY as![CurrencyCode],
            Items.PRODUCT_GUID.PRODUCT_ID as![ProductId],
            Items.PRODUCT_GUID.DESCRIPTION as![ProductDescription]
        }




    //a help view to show product data in different languages
    define view![ProductValueHelp] as
        select from master.product{
            @EndUserText.label: [
                {
                    language: 'EN',
                    text: 'Product Id'
                },
                {
                    language: 'DE',
                    text: 'Prodkt Id'
                }
            ]
            key PRODUCT_ID as![ProductId],
            @EndUserText.label: [
                {
                    language: 'EN',
                    text: 'Product Description'
                },
                {
                    language: 'DE',
                    text: 'Prodkt Beschreibung'
                }
            ]
            DESCRIPTION as![ProductDescription]
        }
   
    define view![ItemView] as
        select from transaction.poitems{
            PARENT_KEY.PARTNER_GUID.NODE_KEY as![BusinessPartnerNodeKey],
            PRODUCT_GUID.NODE_KEY as![ProductNodeKey],
            CURRENCY as![CurrencyCode],
            GROSS_AMOUNT as![GrossAmount],
            NET_AMOUNT as![NetAmount],
            TAX_AMOUNT as![TaxAmount],
           
        };



    define view![ProductView] as
        select from master.product
        //mixin is a keyword to  define lose coupling
        //it will always load product data, when requested, it will load the
        //dataof items on-demad
        mixin{
            //view on view
            PO_ORDER: Association to many ItemView on PO_ORDER.ProductNodeKey = $projection.ProductId
        } into
        {
            key NODE_KEY as![ProductId],
            DESCRIPTION as![ProductDescription],
            CATEGORY as![ProductCategory],
            PRICE as![Price],
            SUPPLIER_GUID.BP_ID as![SupplierId],
            SUPPLIER_GUID.COMPANY_NAME as![SupplierName],
            SUPPLIER_GUID.ADDRESS_GUID.CITY as![SupplierCity],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as![Country],
            //exposed association- @ runtime we can load order data on-demannd
            PO_ORDER as![PurchaseOrders]
        };


    define view CProductValuesView as
        select from ProductView{
            ProductId,
            Country,
            round(sum(PurchaseOrders.GrossAmount),2) as![TotalGrossAmount],
            PurchaseOrders.CurrencyCode as![CurrencyCode]
        }group by ProductId, Country, PurchaseOrders.CurrencyCode;


}
