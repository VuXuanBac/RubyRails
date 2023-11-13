class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params.dig(:session, :password)
      if user.activated?
        # Log the user in and redirect to the user's show page.
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t ".not_activate_notify"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "text.login_fail"
      # flash.now just work with a status:
      render :new, status: :bad_request
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
