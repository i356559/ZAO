@AbapCatalog.sqlViewName: 'ZEYAOCSLSC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Per country'
define view ZEY_AO_C_SALES_PER_COUNTRY as select from ZEY_AO_CO_SALES {
    key _OrderHeader._BusinessPartner.Country,
    sum( _OrderHeader.GrossAmount ) as TotalSales,
    _OrderHeader.Currency
} group by _OrderHeader._BusinessPartner.Country, _OrderHeader.Currency
