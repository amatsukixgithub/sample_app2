class UsersController < ApplicationController

  # only:  editとupdateアクションの前に実行
  # デフォルトでは全てのアクションの前に実行される
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # データベースからひとかたまりのデータ (デフォルトでは30) を取り出す
    @users = User.paginate(page: params[:page])
  end

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

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    # Strong parameters 不要な情報が入り込まないようにする
    def user_params
      # require(:user) user属性を必須とする
      # permit() 指定された属性を許可する
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        # sessionに未ログイン時の遷移先を保存
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
