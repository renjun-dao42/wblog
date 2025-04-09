class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(25)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to admin_users_path, notice: '用户创建成功'
    else
      flash.now[:error] = '用户创建失败'
      render :new, status: 422
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: '用户更新成功'
    else
      flash.now[:error] = '用户更新失败'
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = '用户删除成功'
      redirect_to admin_users_path
    else
      flash[:error] = '用户删除失败'
      redirect_to admin_users_path
    end
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end