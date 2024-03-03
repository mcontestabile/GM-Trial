@EndUserText.label: 'Book BO projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_RAP_BOOKING_GEM as projection on ZRAP_BOOK_CDS_GEM as Booking
{
  key BookingUuid,
      @Search.defaultSearchElement: true
      TravelUuid,
      BookingId,
      BookingDate,
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'} }]
      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      CustomerId,
      _Customer.LastName as CustomerName,
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Carrier', element: 'AirlineID'} }]
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name      as CarrierName,
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                           additionalBinding: [{ localElement: 'CarrierID',    element: 'AirlineID' },
                                                               { localElement: 'FlightDate',   element: 'FlightDate',   usage: #RESULT },
                                                               { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT },
                                                               { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] }]
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      CreatedBy,
      LastChangedBy,
      LocalLastChangedAt,
      
      /* Associations */
      _Carrier,
      _Connection,
      _Currency,
      _Customer,
      _Flight,
      _Travel : redirected to parent ZC_RAP_TRAVEL_GEM
}
