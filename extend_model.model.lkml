connection: "consumer-live"

include: "join_tables.view"

explore: psp {
  extension: required
  view_name: datatable
  sql_always_where: ${datatable.pspaccountid}=(SELECT accountid FROM account WHERE accountcode='AdyenPspService') ;;
}

explore: company {
  extension: required
  view_name: datatable

  join: company {
    from: account
    sql_on: ${datatable.companyaccountid} = ${company.accountid} ;;
    relationship: many_to_one
    type: inner
    fields: [accountcode]
  }
}

explore: merchant {
  extension: required
  view_name: datatable

  join: merchant {
    from: account
    sql_on: ${datatable.merchantaccountid} = ${merchant.accountid} ;;
    relationship: many_to_one
    type: inner
    fields: [accountcode]
  }
}
