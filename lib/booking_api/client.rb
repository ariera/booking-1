module BookingApi
  class Client

    def initialize
      @http_service = HttpService.new
    end

    def http_service
      @http_service
    end

    # checks for the given parameters if the hotel is available
    def get_hotel_availabillity(request_parameters: {}, request_options: {})
      default_parameters = {
        room1: "A,A",
      }
      http_service.request_post("/json/getHotelAvailabilityV2", default_parameters.merge(request_parameters), request_options)
    end

    # gets hotel photos for the given hotel ids
    def hotel_description_photos(hotel_ids: [], request_parameters: {})
      raise ArgumentError if hotel_ids.empty?
      default_parameters = {
        hotel_ids: hotel_ids.join(",")
      }
      response = http_service.request_post("/json/bookings.getHotelDescriptionPhotos", default_parameters.merge(request_parameters))
      Images::ResponseList.new(response)
    end

    # gets detailed descriptions for the given hotels
    def get_hotel_description_translations(request_parameters: {})
      default_parameters = {}
      http_service.request_post("/json/bookings.getHotelDescriptionTranslations", default_parameters.merge(request_parameters))
    end

    # gets an overview of the data for the given hotel ids.
    def get_hotel_overviews(hotel_ids: [], request_parameters: {})
      default_parameters = {}
      default_parameters[:hotel_ids] = hotel_ids.join(",") if hotel_ids.any?
      http_service.request_post("/json/bookings.getHotels", default_parameters.merge(request_parameters))
    end

    private

  end
end


__END__

params = {
  checkin: Time.now.strftime("%F"),
  checkout: (Time.now + (60 * 60 * 24 * 7 * 2)).strftime("%F"),
  hotel_ids: [303762]
}
response = BookingApi::Client.new.get_hotel_availabillity(request_parameters: params)

puts response.body
{
  "checkout": "2016-04-04",
  "hotels": [
    {
      "room_min_price": {
        "price": "750.00"
      },
      "hotel_id": "303762",
      "hotel_currency_code": "EUR"
    }
  ],
  "checkin": "2016-03-21",
  "guest_groups": [
    {
      "guests": 2,
      "children": [

      ]
    }
  ],
  "hotel_ids": [
    "303762"
  ]
}
