class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
    redirect_to root_path if @user.nil?
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t "text.user_welcome"
      redirect_to @user
    else
      redirect_to :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
