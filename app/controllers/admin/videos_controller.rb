class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      flash[:success] = "Video #{@video.title} successfully added."
      redirect_to new_admin_video_path
    else
      flash[:danger] = 'There was an error adding that video, please see details below.'
      render :new
    end

  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover, "video_url")
  end

end