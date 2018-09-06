 - connection: thelook
# 
# - include: "join_tables.view.lookml"
# 
# - explore: psp
#   extension: required
#   view: datatable
#   sql_always_where: ${datatable.pspaccountid}=(SELECT accountid FROM account WHERE accountcode='AdyenPspService')
#   
# - explore: company
#   extension: required
#   view: datatable
#   
#   joins:
#     - join: company
#       from: account
#       sql_on: ${datatable.companyaccountid} = ${company.accountid}
#       relationship: many_to_one
#       type: inner
#       fields: [accountcode]
# 
# - explore: merchant
#   extension: required
#   view: datatable
# 
#   joins: 
#     - join: merchant
#       from: account
#       sql_on: ${datatable.merchantaccountid} = ${merchant.accountid}
#       relationship: many_to_one
#       type: inner
#       fields: [accountcode]