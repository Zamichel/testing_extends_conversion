view: account {
  sql_table_name: public.account ;;

  dimension: accountid {
    primary_key: yes
    type: number
    sql: ${TABLE}.accountid ;;
  }

  dimension: accountcode {
    type: string
    sql: ${TABLE}.accountcode ;;
  }
}

view: genericresponse {
  sql_table_name: public.genericresponsecode ;;

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: responsecode {
    type: number
    sql: ${TABLE}.responsecode ;;
  }
}

view: paymentflag {
  sql_table_name: public.paymentflag ;;

  dimension: paymentflagid {
    primary_key: yes
    type: number
    sql: ${TABLE}.paymentflagid ;;
  }

  dimension: flag {
    type: string
    sql: ${TABLE}.flag ;;
  }
}
