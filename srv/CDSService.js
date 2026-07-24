const cds = require('@sap/cds')

module.exports = class CDSService extends cds.ApplicationService { init() {

  const { POWorklist, ProductView, ItemView } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], POWorklist, async (req) => {
    console.log('Before CREATE/UPDATE POWorklist', req.data)
  })
  this.after ('READ', POWorklist, async (pOWorklist, req) => {
    console.log('After READ POWorklist', pOWorklist)
  })
  this.before (['CREATE', 'UPDATE'], ProductView, async (req) => {
    console.log('Before CREATE/UPDATE ProductView', req.data)
  })
  this.after ('READ', ProductView, async (productView, req) => {
    console.log('After READ ProductView', productView)


    //step 1: get all the unique product ids from the productView
    let ids = productView.map(product => product.ProductId)


    //step 2: get the count of POs for each product id from the POWorklist
    let poCounts = await  SELECT.from(ItemView)
                          .columns('ProductNodeKey',
                            {
                              func: 'count',
                              as: 'POCount'
                            }
                          )
                          .where({ ProductNodeKey: { in: ids } })
                          .groupBy('ProductNodeKey');


    for (const product of productView) {
      const partner = poCounts.find(pc => pc.ProductNodeKey === product.ProductId)
      product.POCount = partner ? partner.POCount : 0
    }




  })

  this.before (['CREATE', 'UPDATE'], ItemView, async (req) => {
    console.log('Before CREATE/UPDATE ItemView', req.data)
  })
  this.after ('READ', ItemView, async (itemView, req) => {
    console.log('After READ ItemView', itemView)
  })


  return super.init()
}}
