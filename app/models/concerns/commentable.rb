module Commentable
  def create_notification_comment(current_user, comment)
    temp_ids = comments.select(:user_id).where.not(user_id: current_user.id)
    if temp_ids.blank?
      current_user.save_notification_comment(comment, comment.commentable.user.id)
    else
      temp_ids.each do |temp_id|
        comment.user.save_notification_comment(comment, temp_id[:user_id])
      end
    end
  end
end
