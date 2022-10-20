@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quantity Per product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEY_AO_C_QTY_PER_PROD as select from ZEY_AO_CO_SALES {
    key _Products.name,
    @Semantics.quantity.unitOfMeasure: 'Unit'
    sum(Quantity) as TotalSold,
    Unit
} group by Unit, _Products.name
