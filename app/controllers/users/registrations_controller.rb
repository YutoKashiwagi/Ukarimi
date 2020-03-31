# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: [:destroy, :update]

  protected

  def after_sign_up_path_for(resource)
    user_path(current_user)
  end
end
