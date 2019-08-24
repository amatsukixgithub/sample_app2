module UsersHelper

  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80)
    #emailアドレスからgravatarのハッシュ化されたidを取得
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    #画像URL
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    #imageタグを返す
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
