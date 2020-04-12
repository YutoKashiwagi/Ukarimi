class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  def configure_permitted_parameters
    # 新規登録時
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # 編集時
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile_image, :profile, :bunri])
  end

  private

  def check_guest
    if current_user.guest?
      flash[:danger] = 'ゲストユーザーは削除、変更できません'
      redirect_back(fallback_location: root_path)
    end
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # https://github.com/heartcombo/devise/blob/079ed3b6f8b671acde2dd630d28d21adb010fb3a/lib/devise/controllers/store_location.rb#L34
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    # https://github.com/heartcombo/devise/blob/079ed3b6f8b671acde2dd630d28d21adb010fb3a/lib/devise/controllers/store_location.rb#L16
    stored_location_for(resource_or_scope) || super
  end
end
