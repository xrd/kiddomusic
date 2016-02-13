class Song < ActiveRecord::Base

  cattr_accessor :cached

  def self.slurp
    @musics = []
    root = File.join( "public", "songs" ) 
    Dir.foreach( root ) do |f|
      unless f =~ /^\.\.?$/
        path = File.join( root, f )
        Mp3Info.open( path ) do |mp3|
          Song.create( { 
                         name: f, 
                         src: "/songs/#{f}", 
                         title: mp3.tag.title, 
                         thumbnail: Song.thumbnail( mp3.tag.title ), 
                         path: path } )
        end
      end
    end
  end

  def self.thumbnail( text )

    # if @@cached[text]

    converted = URI.escape( text + " song" )
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
