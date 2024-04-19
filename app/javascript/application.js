// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "./custom/jquery-3.7.1.min.js";
import "./custom/bootstrap.bundle.min.js";
import "./custom/main";
import "./custom/booking";
import "./custom/admin/booking"
import "./custom/review";
import I18n from "i18n-js";
import "i18n/en";
import "i18n/vi";
window.I18n = I18n;
