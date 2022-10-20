@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity for RAP Business Object for Compostion tree'
define root view entity ZEY_AO_I_M_TRAVEL as select from /dmo/travel  
composition[1..*] of ZEY_AO_I_M_BOOKING as _Bookings 
association[0..1] to ZEY_AO_U_AGENCY as _Agency on
$projection.AgencyId = _Agency.AgencyId
association[0..1] to ZEY_AO_U_CUSTOMER as _Customer on
$projection.CustomerId = _Customer.CustomerId
association[0..1] to I_Currency as _Currency on
$projection.CurrencyCode = _Currency.Currency

{
    key /dmo/travel.travel_id as TravelId,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZEY_AO_U_AGENCY', element: 'AgencyId'} }]
    /dmo/travel.agency_id as AgencyId,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZEY_AO_U_CUSTOMER', element: 'CustomerId'} }]
    /dmo/travel.customer_id as CustomerId,
    /dmo/travel.begin_date as BeginDate,
    /dmo/travel.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    /dmo/travel.booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    /dmo/travel.total_price as TotalPrice,
    /dmo/travel.currency_code as CurrencyCode,
    /dmo/travel.description as Description,
    /dmo/travel.status as Status,
    @Semantics.user.createdBy: true
    /dmo/travel.createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    /dmo/travel.createdat as Createdat,
    @Semantics.user.lastChangedBy: true
    /dmo/travel.lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    /dmo/travel.lastchangedat as Lastchangedat,
    _Bookings, // Make association public
    _Agency,
    _Customer,
    _Currency
}
