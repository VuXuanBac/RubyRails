class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t ".text.create_success"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed
      render "static_pages/home", status: :bad_request
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".text.delete_success"
    else
      flash[:danger] = t ".text.delete_fail"
    end
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.nil?
  end
end
