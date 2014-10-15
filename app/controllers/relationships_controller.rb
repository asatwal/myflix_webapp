class RelationshipsController < ApplicationController


  before_action :require_user

  def index
    @followings = current_user.following_rels
  end

  def create
    leading_user = User.find(params[:leader_id])

    Relationship.create(follower: current_user, leader: leading_user) if current_user.can_follow?leading_user

    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])

    relationship.destroy if relationship && current_user == relationship.follower
    redirect_to people_path
  end
end