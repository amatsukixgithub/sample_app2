require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # testコードで使用するユーザーの作成
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
  end

  # modelオブジェクトが存在しているか
  test "should be valid" do
    assert @user.valid?
  end

  # 空白の名前のユーザーは存在できない
  test "name should be present" do
    @user.name=" "
    assert_not @user.valid?
  end

  # 空白のemailのユーザーは存在できない
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  # 長すぎる名前（51文字以上）は存在できない
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # 長すぎるemail（256文字以上）は存在できない
  test "email should not be too long" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # 正しいemail形式
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # 正しくないemail形式
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # 重複するメールアドレスを拒否
  test "email addresses should be unique" do
    # dup 同じ属性のデータを複製するメソッド
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # DBに保存されたときemailは小文字化されているか
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # パスワードは空白ではない
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # パスワードは6文字以上
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
