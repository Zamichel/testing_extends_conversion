- connection: consumer-live

- include: "*.view.lookml"       
- include: "*.dashboard.lookml"  
- include: "extend_model.model.lookml"
- include: "join_tables.view.lookml"

- label: '000 Extends test'


- explore: table_1
  from: table_1
  label: 'Table 1'
  conditionally_filter: 
    journaldate: 1 day
    companyaccountid: 11073
    merchantaccountid: 11076
    
  
  extends: [psp,company,merchant]
 
  joins:
  - join: genericresponse
    from: genericresponse
    sql_on: ${datatable.acquirerresponsecode}=${genericresponse.responsecode}
    relationship: many_to_one
    type: left_outer
    fields: [description]
    view_label: 'Generic response'
  
  


- explore: table_2
  from: table_2
  label: 'Table 2'
  conditionally_filter: 
    journaldate: 1 day
    companyaccountid: 11073
    merchantaccountid: 11076
    
  
  extends: [psp,company,merchant]

#   joins:
#   - join: paymentflag
#     from: paymentflag
#     sql_on: ${datatable.paymentflagid}=${paymentflag.paymentflagid}
#     relationship: many_to_one
#     type: inner
#     fields: [flag]
#     view_label: 'Payment flag'