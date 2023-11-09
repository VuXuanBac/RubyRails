class AccountActivationsController < ApplicationController
  before_action :find_user, only: :edit

  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t ".text.activate_success"
      redirect_to @user
    else
      flash[:danger] = t ".text.activate_fail"
      redirect_to root_url
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:email]
    flash[:danger] = t ".text.user_not_found"
    redirect_to root_path unless @user
  end
end
