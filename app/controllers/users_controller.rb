class UsersController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @users = User.all
  end

  def show
    logger.debug("showの中に入りました")
    @user = User.find(params[:id])
    logger.debug("whereの前")
    user = User.where(id: params[:id])
    logger.debug("whereの後")
    logger.debug(user[0].id)
    logger.debug(user[0].name)
    logger.debug(user[0].introduction)
    logger.debug(user[0].profile_image_id)
    logger.debug("ログ出たかな")

    @books = Book.where(user_id: params[:id])
    @notice = flash[:notice]
    # @books = Book.all
  end

  def edit
    logger.debug(params[:id])
    logger.debug(current_user.id)
    if params[:id].to_i == current_user.id
      logger.debug("同じユーザ")
      @user = User.find(current_user.id)
    else
      logger.debug("違うユーザ")
      redirect_to user_path(current_user.id)
    end
  end

  def update
    logger.debug("updateの中に入りました")
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'You have updated user info successfully.'
      redirect_to user_path(@user.id)
    else
      logger.debug('user save 失敗')
      flash[:notice] = 'update user error happen.'
#      redirect_to edit_user_path(@user.id)
#      redirect_to user_path(@user.id)
       render :edit
#      render edit_user_path(params[:id])
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
