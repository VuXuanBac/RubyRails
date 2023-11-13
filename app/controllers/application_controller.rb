class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale

  private
  # Set application locale before loading.
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.available_locales.include?(locale) ? locale
                                          : I18n.default_locale
    @pagy_locale = params[:locale]
  end

  def default_url_options
    {locale: I18n.locale}
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "text.require_login"
      redirect_to login_url
    end
  end
end
