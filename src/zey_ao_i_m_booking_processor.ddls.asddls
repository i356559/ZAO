@EndUserText.label: 'Booking processor projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.headerInfo:{
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title: { type: #STANDARD, value: 'BookingID' }
    
}


define view entity ZEY_AO_I_M_BOOKING_PROCESSOR as projection on ZEY_AO_I_M_BOOKING {
    @UI.facet: [{
        id: 'BookingDetails',
        label: 'Booking Details',
        purpose: #STANDARD,
        type: #IDENTIFICATION_REFERENCE
     }]
     @UI.identification: [{position: 10 }]
    key TravelId,
    @UI.lineItem: [{position: 10 }]
    @UI.identification: [{position: 20 }]
    key BookingId,
    @UI.lineItem: [{position: 20 }]
    @UI.identification: [{position: 30 }]
    BookingDate,
    @UI.lineItem: [{position: 30 }]
    @UI.identification: [{position: 40 }]
    @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Customer', element: 'CustomerID'} }]
    CustomerId,
    @UI.lineItem: [{position: 40 }]
    @UI.identification: [{position: 50 }]
    @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Carrier', element: 'AirlineID'} }]
    CarrierId,
    @UI.lineItem: [{position: 50 }]
    @UI.identification: [{position: 60 }]
    @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                          additionalBinding: [{ localElement: 'FlightDate', element: 'FlightDate' },
                                          { localElement: 'CarrierId', element: 'AirlineID' },
                                          { localElement: 'FlightPrice', element: 'Price' },
                                          { localElement: 'CurrencyCode', element: 'CurrencyCode' }] }]
    ConnectionId,
    @UI.lineItem: [{position: 60 }]
    @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                          additionalBinding: [{ localElement: 'FlightDate', element: 'FlightDate' },
                                          { localElement: 'CarrierId', element: 'AirlineID' },
                                          { localElement: 'FlightPrice', element: 'Price' },
                                          { localElement: 'CurrencyCode', element: 'CurrencyCode' }] }]
    @UI.identification: [{position: 70 }]
    FlightDate,
    @UI.lineItem: [{position: 70 }]
    @UI.identification: [{position: 80 }]
    FlightPrice,
    CurrencyCode,
    Lastchangedat,
    /* Associations */
    _Carrier,
    _Connection,
    _Customer,
    _Travel: redirected to parent ZEY_AO_I_M_TRAVEL_PROCESSOR
}
