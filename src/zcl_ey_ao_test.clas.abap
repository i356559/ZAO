CLASS zcl_ey_ao_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ey_ao_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    data: lv_price type int4,
          lv_dis_price type int4.

      zcl_ey_ao_amdp=>getproductdata(
        EXPORTING
          p_id               = '6ED48F210DBC1EDD92A2DB1634AAE142'
        IMPORTING
          e_price            =  lv_price
          e_discounted_price = lv_dis_price
      ).

    out->write(
      EXPORTING
        data   = |The price and discounted is here { lv_price } and { lv_dis_price }|
*        name   =
*      RECEIVING
*        output =
    ).

  ENDMETHOD.
ENDCLASS.
