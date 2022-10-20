@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES DATA ANALYTICS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEY_AO_SALES_DATA as select from zey_ao_so 
association[1] to ZEY_AO_TF as _OrderDetails
on $projection.OrderNo = _OrderDetails.order_no
{
    key order_id as OrderId,
    order_no as OrderNo,
    buyer as Buyer,
    @Semantics.amount.currencyCode: 'Currency'
    gross_amount as GrossAmountOriginal,
    currency as Currency,
    created_by as CreatedBy,
    created_on as CreatedOn,
    changed_by as ChangedBy,
    changed_on as ChangedOn,
    _OrderDetails
}
