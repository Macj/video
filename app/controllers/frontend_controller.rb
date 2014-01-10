class FrontendController < ApplicationController
  def index
    @users = User.all
  end
end