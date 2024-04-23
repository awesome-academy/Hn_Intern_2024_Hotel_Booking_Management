class Users::RegistrationsController < Devise::RegistrationsController
  layout :specific_layout

  def after_update_path_for resource
    if resource.user?
      request.referer || root_path
    else
      request.referer || admin_dashboard_path
    end
  end

  private
  def specific_layout
    resource.admin? ? "admin/layouts/application" : "layouts/application"
  end
end
