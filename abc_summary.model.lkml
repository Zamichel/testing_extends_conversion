connection: "consumer-live"

include: "*.view"

include: "*.dashboard"

include: "extend_model.model"

include: "join_tables.view"

label: "000 Extends test"

explore: table_1 {
  from: table_1
  label: "Table 1"

  conditionally_filter: {
    filters: {
      field: journaldate
      value: "1 day"
    }

    filters: {
      field: companyaccountid
      value: "11073"
    }

    filters: {
      field: merchantaccountid
      value: "11076"
    }
  }

  extends: [psp, company, merchant]

  join: genericresponse {
    from: genericresponse
    sql_on: ${datatable.acquirerresponsecode}=${genericresponse.responsecode} ;;
    relationship: many_to_one
    type: left_outer
    fields: [description]
    view_label: "Generic response"
  }
}

explore: table_2 {
  from: table_2
  label: "Table 2"

  conditionally_filter: {
    filters: {
      field: journaldate
      value: "1 day"
    }

    filters: {
      field: companyaccountid
      value: "11073"
    }

    filters: {
      field: merchantaccountid
      value: "11076"
    }
  }

  extends: [psp, company, merchant]
}

#   joins:
#   - join: paymentflag
#     from: paymentflag
#     sql_on: ${datatable.paymentflagid}=${paymentflag.paymentflagid}
#     relationship: many_to_one
#     type: inner
#     fields: [flag]
#     view_label: 'Payment flag'
