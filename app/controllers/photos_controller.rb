class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  def create
  @photo = Photo.new
  @photo.caption = params.fetch("query_caption")
  @photo.image = params.fetch("query_image")
  @photo.activity_id = params.fetch("query_activity_id")

  if @photo.save
    redirect_to("/activities/#{@photo.activity_id}", { :notice => "Photo created successfully." })
  else
    redirect_to("/activities/#{@photo.activity_id}", { :alert => "Photo failed to create." })
  end
end


  # PATCH/PUT /photos/1
  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: "Photo was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /photos/1
  def destroy
    @photo.destroy!
    redirect_to photos_path, notice: "Photo was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.expect(photo: [ :caption, :image, :activity_id ])
    end
end
