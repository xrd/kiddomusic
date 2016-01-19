class Song < ActiveRecord::Base

  @@cached = {}

  def self.thumbnail( text )
    converted = URI.escape( text )
    url =  "https://#{ENV['LIVE_AUTH_INFORMATION']}@api.datamarket.azure.com/Bing/Search/Image?Query=%27#{converted}%27&Adult=%27Moderate%27&$format=JSON"
    logger.info "URL: #{url}"
    conn = Faraday.new(:url => url ) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    response = conn.get
    JSON.parse( response.body )['d']['results'][0]['MediaUrl']
  end



end
