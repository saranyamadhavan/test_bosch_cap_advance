using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';
 
 
service CatalogService @(path:'/CatalogService') {
   
    @readonly
    entity EmployeeSet as projection on master.employees;
    @Capabilities.InsertRestrictions : {
        $Type : 'Capabilities.InsertRestrictionsType',
        Insertable : false
    }
    entity ProductSet as projection on master.product;
    entity SupplierSet as projection on master.businesspartner;
    entity PurchaseItemSet as projection on transaction.poitems;
    entity AddressSet as projection on master.address;
    entity statusCodeSet as projection on master.StatusCode;
    entity PurchaseOrderSet
        @( odata.draft.enabled: true,
        odata.draft.bypass: true )
    as projection on transaction.purchaseorder{
        *,
        case OVERALL.STATUS
            when 'A' then 3
            when 'R' then 1
            when 'P' then 2
            else 0
        end as Spiderman : Integer,
        case OVERALL.STATUS
            when 'A' then 'Approved'
            when 'D' then 'Delivered'
            when 'X' then 'Cancelled'
            when 'P' then 'Pending'
            else 'Unknown'
        end as Description: String(10)
 
    }
    actions{
        //instance bound - the system will pass PO_ID to the action automatically
         // it is a feature where we inform FIori that a GET call is required to fetch the
        // data after executing the action because it has a side effect on the GROSS_AMOUNT field
        @Common.SideEffects: {
            $Type : 'Common.SideEffectsType',
            TargetProperties : [ 'GROSS_AMOUNT' ]
        }
        action boost() returns PurchaseOrderSet;
    };
 
    //non instance bound - the system will not pass any parameter to the action
    //function
    function getLargestOrder() returns PurchaseOrderSet;
 
 
}
 
 