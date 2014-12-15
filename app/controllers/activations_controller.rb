class ActivationsController < ApplicationController
  def activate
    user = User.where(activation_token: params[:token]).first
    user.activate! if user.present?
  end
end
