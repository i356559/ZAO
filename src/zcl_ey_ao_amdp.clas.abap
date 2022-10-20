CLASS zcl_ey_ao_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS getproductData
    IMPORTING
        VALUE(p_id) type zey_ao_dte_id
    EXPORTING
        value(e_price) type int4
        value(e_discounted_price) type int4.

    CLASS-METHODS getorders for table function ZEY_AO_TF.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ey_ao_amdp IMPLEMENTATION.
  METHOD getproductdata by DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY using zey_ao_product.

    declare lv_price, lv_discount integer;
    select price, discount into lv_price, lv_discount
    from zey_ao_product where product_id = :p_id;

    e_price = :lv_price;
    e_discounted_price = ( :lv_price * ( 100 - :lv_discount ) / 100 );

  ENDMETHOD.

  METHOD getorders by DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY using zey_ao_product zey_ao_so zey_ao_so_i.

       lt_orders = SELECT hdr.client, hdr.order_no, item.amount,
                    ( item.amount * ( 100 - prod.discount ) / 100 )
                    as gross_dis_amount
                     from zey_ao_so as hdr
                    inner join zey_ao_so_i as item
                    on hdr.order_id = item.order_id
                    inner join zey_ao_product as prod
                    on item.product = prod.product_id
                    where hdr.client = :p_clnt;

       return select client, order_no, sum( amount ) as gross_amount,
       sum( gross_dis_amount ) as gross_dis_amount from :lt_orders
       group by client, order_no;

  ENDMETHOD.

ENDCLASS.
