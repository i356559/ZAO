@EndUserText.label: 'Travel Approver'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo:{
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {value: 'TravelId', label: 'Travel ID'},
    description: { label: 'Description', value: 'Description'}
}
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZEY_AO_I_M_TRAVEL_APPROVER as projection on ZEY_AO_I_M_TRAVEL {
    @Search.defaultSearchElement: true
        @ObjectModel.text.element: ['Description']
    key TravelId,
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZEY_AO_U_AGENCY', element: 'AgencyId'} }]
        @ObjectModel.text.element: ['AgencyName']
    AgencyId,
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZEY_AO_U_CUSTOMER', element: 'CustomerId'} }]
    @ObjectModel.text.element: ['CustomerName']
    CustomerId,
    _Agency.Name as AgencyName,
    _Customer.FirstName as CustomerName,
    BeginDate,
    EndDate,
    BookingFee,
    TotalPrice,
    CurrencyCode,
    Description,
    Status,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Agency,
    _Bookings: redirected to composition child ZEY_AO_I_M_BOOKING_APPROVER,
    _Currency,
    _Customer
}
