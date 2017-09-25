class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @run1 = Run.where(user_id: @user.id)
    @q= @run1.ransack(params[:q])
    @run = @q.result(distinct: true)
  end
end
