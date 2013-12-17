class GmapsController < ApplicationController
  def search
    if params[:address].present?
      begin
        location = Geocoder.search(params[:address])
        @client = GooglePlaces::Client.new('AIzaSyCCXNMqwpWnmgaq10pkFun_Vupfr0aIaGc')
        @locations =  @client.spots(location.first.latitude, location.first.longitude, :types => [params[:type]])
        unless @locations.present?
          @locations =  @client.spots(location.first.latitude, location.first.longitude)
        end
        @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
          marker.lat location.lat
          marker.lng location.lng
          marker.title location.name
          marker.infowindow "#{location.name} <br/> #{location.vicinity}"
        end
      rescue
        redirect_to :back
      end
    end
  end
end
