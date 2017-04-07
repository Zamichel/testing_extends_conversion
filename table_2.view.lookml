- view: table_2
  sql_table_name: summaries.paymentflaggingbinsummary
  fields:


## Dimensions common to multiple views
  - dimension: pspaccountid
    type: number
    value_format_name: id
    sql: ${TABLE}.pspaccountid
    hidden: true
    
  - dimension: companyaccountid
    type: number
    value_format_name: id
    sql: ${TABLE}.companyaccountid
    hidden: true
    
  - dimension: merchantaccountid
    type: number
    value_format_name: id
    sql: ${TABLE}.merchantaccountid
    hidden: true
    
  - dimension: journaldate
    type: date
    sql: ${TABLE}.journaldate

  
## Dimensions unique to this view
  - dimension: paymentflagid
    type: number
    value_format_name: id
    sql: ${TABLE}.paymentflagid
    hidden: true

## Measures
  - measure: appliedauthorised
    type: sum
    sql: ${TABLE}.appliedauthorised

  - measure: appliedtotal
    type: sum
    sql: ${TABLE}.appliedtotal

