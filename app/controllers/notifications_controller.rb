class NotificationsController < ApplicationController
  before_action :authenticate_user!
  after_action :check_notifications

  def index
    @notifications = current_user.passive_notifications.
      includes(:visitor, :visited).page(params[:page]).per(10)
  end

  private

  def check_notifications
    notifications = current_user.passive_notifications.includes(:visitor, :visited)
    notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end
