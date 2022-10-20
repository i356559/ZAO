@AbapCatalog.sqlViewName: 'ZEYAOIPROD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'product basic, interface'
define view zey_ao_i_product as select from zey_ao_product {
    key product_id as ProductId,
    name as Name,
    category as Category,
    price as Price,
    currency as Currency,
    discount as Discount
}
