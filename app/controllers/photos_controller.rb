class PhotosController < ApplicationController
  before_action :authenticate_user!

  def index
    @photos = current_user
              .photos
              .page(params[:page])
              .order(ig_timestamp: :desc)
  end

  def show
    @photo = current_user.photos.find(params[:id])
  end
end
