class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :topics, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower


  mount_uploader :avatar, AvatarUploader


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        image_url: auth.info.image,
        password: Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  #クラスメソッドであるfind_for_twitter_oauthを設定
  def self.find_for_twitter_oauth(auth,signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
      name: auth.info.nickname,
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
      image_url: auth.info.image,
      password: Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  def self.find_for_google_oauth(auth,signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
      name: auth.info.name,
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
      image_url: auth.info.image,
      password: Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  def self.find_for_yahoo_oauth(auth,signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
      name: auth.info.name,
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
      image_url: auth.info.image,
      password: Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  #クラスメソッドとして、ランダムなユーザーidを作成
  def self.create_unique_string
   SecureRandom.uuid
  end

  #パスワードの更新
  def update_with_password(params, *options)
    if provider.blank?
      super
    else
      params.delete :current_password
      update_without_password(params, *options)
    end
  end

  #フォロー
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  #フォローしているかの確認
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  #フォロー解除
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

end
