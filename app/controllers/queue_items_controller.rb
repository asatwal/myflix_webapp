class QueueItemsController < ApplicationController

  layout "application"

  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    queue_item = QueueItem.new(video_id: params[:video_id], user: current_user, position: new_queue_item_position)

    if (!queue_item.save)
      flash[:danger] = 'Error adding queue item'
    end

    @queue_items = current_user.queue_items
    render :index
  end

  def destroy
    queue_item = QueueItem.find(params[:id])

    if (queue_item && (queue_item.user_id == current_user.id) && !queue_item.destroy)
      flash[:danger] = 'Error deleting queue item'
    end

    @queue_items = current_user.queue_items
    render :index
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

end
