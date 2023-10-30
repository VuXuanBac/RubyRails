class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(edit update)
  before_action :check_expiration, only: [:edit, :update]

  def new;end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email).downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".text.mail_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".text.invalid_email"
      render :new, status: :bad_request
    end
  end

  def edit;end

  def update
    if params.dig(:user, :password).empty?
      @user.errors.add :password, t(".text.empty_pwd")
      render :edit, status: :bad_request
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".text.reset_success"
      redirect_to @user
    else
      render :edit, status: :bad_request
    end
  end

  private
    def user_params
      params.require(:user).permit :password, :password_confirmation
    end

    def get_user
      @user = User.find_by email: params[:email]
      # Validate
      return if @user&.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = t ".text.token_expire"
        redirect_to new_password_reset_url
      end
    end

end
