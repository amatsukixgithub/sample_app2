class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  # validates (:name, presence: true)

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false } # case_sensitive 大文字小文字を区別しない

  has_secure_password
  validates :password, presence: true, length: { minimum: 6}

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    # costはハッシュを算出するための計算コストを指定
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
