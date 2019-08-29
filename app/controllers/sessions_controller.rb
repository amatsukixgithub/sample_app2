class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # has_secure_password によって追加される authenticateメソッド
    # 引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # sessionに保存した遷移先へリダイレクト
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
