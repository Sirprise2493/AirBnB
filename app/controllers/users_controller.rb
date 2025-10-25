class UsersController < ApplicationController
  def show
    @user     = User.find(params[:id])
    @reviews  = @user.reviews.includes(:listing).order(created_at: :desc)
    avg       = @reviews.average(:rating) || 0
    @avg_rate = avg.to_f.round(2)
  end
end
