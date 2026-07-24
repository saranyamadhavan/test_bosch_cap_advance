using CatalogService as service from '../../srv/CatalogService';

annotate service.PurchaseOrderSet with @(
    
   // selection fields - first screen, adding filter fields in smart filter bar
    UI.SelectionFields:[
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        CURRENCY_code,
        OVERALL_STATUS
    ],

    // line item fields - first screen, displaying details in a table
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
        {
            $Type : 'UI.DataField',
            Value : OVERALL_STATUS,
            Criticality : Spiderman
        }
    ],
        



    // Title on table, next screen top area
    UI.HeaderInfo: {
        TypeName: 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title: { Value: PO_ID },
        Description: { Value: OVERALL.description },
        ImageUrl : 'https://1000logos.net/wp-content/uploads/2016/10/Bosch-Logo.png',
    },

    UI.Facets : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets : [
                // first and default block is identification
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification',
                    Label : 'Basic Data'
                },
                 //more than one - field group
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#Spiderman',
                    Label : 'Pricing Info'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#Batman',
                    Label : 'Delivery Info'
                }

            ],
        },
         {
            $Type : 'UI.ReferenceFacet',
            Target : 'Items/@UI.LineItem',
            Label : 'Items'
        },

    ],

    // identification block - first block on next screen, top area
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY
        },
        {
            $Type : 'UI.DataField',
            Value : LIFECYCLE_STATUS,
        },
    ],

    // field group - second block on next screen, middle area
    UI.FieldGroup #Spiderman: {
        Label : 'Pricing Info',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
        ],
    },

    // field group - third block on next screen, bottom area
    UI.FieldGroup #Batman: {
        Label : 'Delivery Info',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
            {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS,
            },
        ],
    },

);


annotate service.PurchaseItemSet with @(

    UI.HeaderInfo: {
        TypeName: 'Purchase Order Item',
        TypeNamePlural: 'Purchase Order Items',
        Title: { Value: PO_ITEM_POS },
        Description: { Value: PRODUCT_GUID.DESCRIPTION },
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.Identification',
            Label : 'Item Data'
        },
    ],
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
    ],


    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.CATEGORY,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.DESCRIPTION,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
    ],


);



// Adding value help for overall status field, so that user can see the description of the status code
annotate service.PurchaseOrderSet with {
    @Common.Text: OVERALL.description
    @Common.ValueList :{
        $Type : 'Common.ValueListType/FixedValues',
        CollectionPath : 'statusCodeSet',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterOut',
                LocalDataProperty : OVERALL,
                ValueListProperty : 'STATUS'
            },
            {
                $Type : 'Common.ValueListParameterOut',
                LocalDataProperty : OVERALL,
                ValueListProperty : 'description'
            }            
        ],
        Label : 'Overall Status'
    }
    @Common.ValueListWithFixedValues: true
    OVERALL;


    @Common.Text: PARTNER_GUID.COMPANY_NAME
    @Valuelist.entity: service.SupplierSet
    PARTNER_GUID;

};


annotate service.PurchaseItemSet with {
   
    @Common.Text: PRODUCT_GUID.DESCRIPTION
    @Valuelist.entity: service.ProductSet
    PRODUCT_GUID;
};


//design a f4 help that shows the technical id and name of business partner
@cds.odata.valuelist
annotate service.SupplierSet with @(
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        }
    ],
);


@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        }
    ],
);
