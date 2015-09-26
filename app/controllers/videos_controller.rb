class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload 
    ams = AzureMediaService.service
    puts "UPLOADING FILE"
    asset = ams.upload_media(params[:file].path)
    puts "PUBLISHING"
    policy = AzureMediaService::AccessPolicy.create(name: 'policy1',duration_minutes: 300, permission: 1)
    locator = AzureMediaService::Locator.create(policy_id: policy.Id, asset_id: asset.Id, type: 1)
    puts asset.files
    puts "ASSETTTTTT"
    puts asset
    puts "PUBLISH COMPLETE"


    puts locator
    pub_url = asset.Uri+"/"+asset.files[0].Name+locator.ContentAccessComponent
    vid = Video.new
    vid.url = pub_url
    vid.save
    
    puts "ENCODING"
    job = asset.encode_job('H264 Adaptive Bitrate MP4 Set SD 4x3 for iOS Cellular Only')
    vid.job_id = job.Id
    puts job.uri
    puts "!!!!!!!!!!!!!"
    puts vid.job_id
    vid.save
    puts "ENCODING COMPLETE"
    puts job
    

    puts asset.Uri+"/"+asset.files[0].Name+locator.ContentAccessComponent
    redirect_to welcome_path
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:url, :job_id, :low_res_url)
    end
end
