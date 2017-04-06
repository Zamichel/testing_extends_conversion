view: table_1 {
  sql_table_name: summaries.acquirerbinconversiondailysummary ;;
  ## Dimensions common to multiple views
  dimension: pspaccountid {
    type: number
    value_format_name: id
    sql: ${TABLE}.pspaccountid ;;
    hidden: yes
  }

  dimension: companyaccountid {
    type: number
    value_format_name: id
    sql: ${TABLE}.companyaccountid ;;
    hidden: yes
  }

  dimension: merchantaccountid {
    type: number
    value_format_name: id
    sql: ${TABLE}.merchantaccountid ;;
    hidden: yes
  }

  dimension: journaldate {
    type: date
    sql: ${TABLE}.journaldate ;;
  }

  ## Dimensions unique to this view
  dimension: acquirerresponsecode {
    type: number
    sql: ${TABLE}.acquirerresponsecode ;;
    hidden: yes
  }

  ## Measures
  measure: authorisedcount {
    type: sum
    sql: ${TABLE}.authorisedcount ;;
  }

  measure: receivedcount {
    type: sum
    sql: ${TABLE}.authorisedcount+${TABLE}.refusedbyacquirercount ;;
  }
}
