class Admin::BaseController < ApplicationController
  layout "admin/layouts/application"

  before_action :require_admin
end
