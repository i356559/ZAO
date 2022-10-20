@AbapCatalog.sqlViewName: 'ZEYAOCOSLS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales order header composite'
define view zey_ao_co_salesorder as select from zey_ao_so 
association[1] to ZEY_AO_I_BP as _BusinessPartner on
$projection.Buyer = _BusinessPartner.BpId
{
    key zey_ao_so.order_id as OrderId,
    zey_ao_so.order_no as OrderNo,
    zey_ao_so.buyer as Buyer,
    zey_ao_so.gross_amount as GrossAmount,
    zey_ao_so.currency as Currency,
    zey_ao_so.created_by as CreatedBy,
    zey_ao_so.created_on as CreatedOn,
    zey_ao_so.changed_by as ChangedBy,
    zey_ao_so.changed_on as ChangedOn,
    _BusinessPartner
}
