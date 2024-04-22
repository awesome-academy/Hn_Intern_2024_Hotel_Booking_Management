class Admin::BaseController < ApplicationController
  layout "admin/layouts/application"

  include Admin::UsersHelper

  before_action :require_admin
end
