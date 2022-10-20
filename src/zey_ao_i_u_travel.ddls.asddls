@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View for Travel Un managed scenario'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZEY_AO_I_U_TRAVEL as select from /dmo/travel as Travel 
association[1] to ZEY_AO_U_AGENCY as _Agency on 
$projection.AgencyId = _Agency.AgencyId
association[1] to ZEY_AO_U_CUSTOMER as _Customer on 
$projection.CustomerId = _Customer.CustomerId
association[1] to I_Currency as _Currency on 
$projection.CurrencyCode = _Currency.Currency
association[1] to /DMO/I_Travel_Status_VH as _TravelStatus on 
$projection.Status = _TravelStatus.TravelStatus
{   
    @ObjectModel.text.element: ['Description']
    key Travel.travel_id as TravelId,
    @ObjectModel.text.element: ['AgencyName']
    Travel.agency_id as AgencyId,
    _Agency.Name as AgencyName,
    @ObjectModel.text.element: ['CustomerName']
    Travel.customer_id as CustomerId,
    _Customer.FirstName as CustomerName,
    Travel.begin_date as BeginDate,
    Travel.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Travel.booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Travel.total_price as TotalPrice,
    Travel.currency_code as CurrencyCode,
    Travel.description as Description,
    case status
        when 'N' then 3 --green
        when 'B' then 2 --yellow
        when 'X' then 1 -- red
        when 'P' then 3
        else 0 end as Criticality,
    @ObjectModel.text.element: ['StatusText']
    Travel.status as Status,
    _TravelStatus._Text[ Language = 'E' ].Text as StatusText,
    Travel.createdby as Createdby,
    Travel.createdat as Createdat,
    Travel.lastchangedby as Lastchangedby,
    Travel.lastchangedat as Lastchangedat,
    _Agency,
    _Customer,
    _Currency,
    _TravelStatus
}
