const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, SupplierSet, PurchaseItemSet, PurchaseOrderSet } = cds.entities('CatalogService')

  this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSet', req.data)

        //here i get all the data which was passed for Create operation
    //now i can include some validation code, if i am not happy with the data
    //i can throw an error and the create operation will not be executed
    if(parseFloat(req.data.salaryAmount) >= 1000000){
      //throw an error and the create operation will not be executed
      req.error(400, 'Salary amount is more than a million');
    }

  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], SupplierSet, async (req) => {
    console.log('Before CREATE/UPDATE SupplierSet', req.data)
  })
  this.after ('READ', SupplierSet, async (supplierSet, req) => {
    console.log('After READ SupplierSet', supplierSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseItemSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseItemSet', req.data)
  })
  this.after ('READ', PurchaseItemSet, async (purchaseItemSet, req) => {
    console.log('After READ PurchaseItemSet', purchaseItemSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
    console.log('After READ PurchaseOrderSet', purchaseOrderSet)
  })
  this.on('boost', PurchaseOrderSet, async (req) => {


    const pk = req.params[0];


    console.log('Boost action called for PurchaseOrderSet with PO_ID:', JSON.stringify(pk));


    //goal was to change the gross amount of the purchase order by +20000
    //step 1: get access to the transaction api
    const tx = cds.tx(req);
    //step 2: change the order amount +20000 for the given pk
    const result = await tx.update(PurchaseOrderSet)
                  .set({ GROSS_AMOUNT: { '+=': 20000 } }).where(pk);


    return result;


  });

  this.on('getLargestOrder', async (req) => {


    //goal was to change the gross amount of the purchase order by +20000
    //step 1: get access to the transaction api
    const tx = cds.tx(req);
    //step 2: change the order amount +20000 for the given pk
    const result = await tx.read(PurchaseOrderSet)
                  .orderBy({GROSS_AMOUNT : 'desc'}).limit(1);


    return result;


  });


  return super.init()
}}
