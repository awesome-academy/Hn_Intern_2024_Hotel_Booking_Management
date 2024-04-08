class Users::RegistrationsController < Devise::RegistrationsController
  def after_update_path_for resource
    if resource.user?
      request.referer || root_path
    else
      request.referer || admin_dashboard_path
    end
  end
end
