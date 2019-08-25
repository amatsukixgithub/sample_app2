class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    # debugger
    @user = User.find(params[:id])
  end

  def create
    # @user = User.new(params[:user])    # マスアサインメント　脆弱性あり
    @user = User.new(user_params)
    if @user.save
      log_in @user #sessionヘルパー
      flash[:success] = 'Welcome to the Sample App!'

      # redirect_to user_url(@user) と同じ
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      # require(:user) user属性を必須とする
      # permit() 指定された属性を許可する
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
