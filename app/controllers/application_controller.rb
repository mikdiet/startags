class ApplicationController < ActionController::Base
  include AuthorizedController
  protect_from_forgery with: :exception
end
