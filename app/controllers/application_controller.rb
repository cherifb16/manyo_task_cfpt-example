class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  include SessionsHelper

  before_action :login_required

  private
    def login_required
      redirect_to new_session_path, alert: "Please log in." unless current_user
    end

    def already_logged_in
      redirect_to tasks_path, alert: "Please log in." if current_user
    end
end
