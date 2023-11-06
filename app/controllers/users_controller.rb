class UsersController < ApplicationController

  before_action :find_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.sort_list
  end

  def show;end

  def new
    @user = User.new
  end

  def edit;end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "text.user_welcome"
      redirect_to @user
    else
      render :new, status: :bad_request
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t ".text.update_success"
      redirect_to @user
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".text.delete_success"
    else
      flash[:danger] = t ".text.delete_fail"
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def find_user
      @user = User.find_by id: params[:id]
      return if @user

      redirect_to root_path
    end

    ########  BEFORE FILTERS  #######
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t "text.require_login"
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      redirect_to root_url unless current_user? @user
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
