class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      # user.authenticate
      redirect_to user
    else
      # Create an error message.
      flash.now[:danger] = 'Error login'
      render 'new'
    end
  end

  def destroy

  end
end
