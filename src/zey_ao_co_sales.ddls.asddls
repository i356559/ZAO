@AbapCatalog.sqlViewName: 'ZEYAOCOSALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales order details'
define view ZEY_AO_CO_SALES as select from zey_ao_so_i 
association[0..1] to zey_ao_i_product as _Products on
$projection.Product = _Products.ProductId
association[0..1] to zey_ao_co_salesorder as _OrderHeader on
$projection.OrderId = _OrderHeader.OrderId
{
    key zey_ao_so_i.item_id as ItemId,
    zey_ao_so_i.order_id as OrderId,
    zey_ao_so_i.product as Product,
    zey_ao_so_i.amount as Amount,
    zey_ao_so_i.currency as Currency,
    zey_ao_so_i.quantity as Quantity,
    zey_ao_so_i.unit as Unit,
    zey_ao_so_i.created_by as CreatedBy,
    zey_ao_so_i.created_on as CreatedOn,
    zey_ao_so_i.changed_by as ChangedBy,
    zey_ao_so_i.changed_on as ChangedOn,
    _Products,
    _OrderHeader
}
