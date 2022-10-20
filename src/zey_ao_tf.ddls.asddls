@EndUserText.label: 'table Function'
define table function ZEY_AO_TF
with parameters 
@Environment.systemField: #CLIENT
p_clnt : abap.clnt
returns {
  client : abap.clnt;
  order_no : abap.int4;
  gross_amount : abap.int4;
  gross_dis_amount : abap.int4;
  
}
implemented by method zcl_ey_ao_amdp=>getorders;