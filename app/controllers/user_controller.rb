# frozen_string_literal: true

class UserController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
end
