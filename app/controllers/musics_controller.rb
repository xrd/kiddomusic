require 'uri'

class MusicsController < ApplicationController
  before_action :set_music, only: [:show, :edit, :update, :destroy]

  def thumbnails
    url =  "https://#{ENV['LIVE_AUTH_INFORMATION']}@api.datamarket.azure.com/Bing/Search/Image?Query=%27animals%27&Adult=%27Moderate%27&$format=JSON"
    conn = Faraday.new(:url => url ) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    response = conn.get
    render json: JSON.parse( response.body )
  end

  # GET /musics
  # GET /musics.json
  def index
    # @musics = Music.all
    @musics = []
    root = File.join( "public", "songs" ) 
    Dir.foreach( root ) do |f|
      unless f =~ /^\.\.?$/
        Mp3Info.open( File.join( root, f ) ) do |mp3|
          @musics << { name: f, src: "/songs/#{f}", title: mp3.tag.title, thumbnail: Song.thumbnail( mp3.tag.title ) }
        end
      end
    end
    respond_to do |f|
      f.html {}
      f.json { render json: @musics }
    end
  end

  # GET /musics/1
  # GET /musics/1.json
  def show
  end

  # GET /musics/new
  def new
    @music = Music.new
  end

  # GET /musics/1/edit
  def edit
  end

  # POST /musics
  # POST /musics.json
  def create
    @music = Music.new(music_params)

    respond_to do |format|
      if @music.save
        format.html { redirect_to @music, notice: 'Music was successfully created.' }
        format.json { render :show, status: :created, location: @music }
      else
        format.html { render :new }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musics/1
  # PATCH/PUT /musics/1.json
  def update
    respond_to do |format|
      if @music.update(music_params)
        format.html { redirect_to @music, notice: 'Music was successfully updated.' }
        format.json { render :show, status: :ok, location: @music }
      else
        format.html { render :edit }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musics/1
  # DELETE /musics/1.json
  def destroy
    @music.destroy
    respond_to do |format|
      format.html { redirect_to musics_url, notice: 'Music was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = Music.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
      params[:music]
    end
end
