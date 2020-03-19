class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.where(checked: false).page(params[:page]).per(10)
    @notifications.each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end
