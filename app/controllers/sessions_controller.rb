class SessionsController < ApplicationController
  def new;end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_to user
    else
      # Create an error message.
      flash.now[:danger] = t "text.login_fail"
      # flash.now just work with a status:
      render :new, status: :bad_request
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
