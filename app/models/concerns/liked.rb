module Liked
  def liked_users
    likes.map(&:user)
  end

  def liked?(user)
    liked_users.include?(user)
  end

  def liked_by(user)
    likes.where(user: user).first_or_create
  end

  def unliked_by(user)
    likes.find_by(user: user).destroy if liked?(user)
  end
end
