module ApplicationHelper
   def active_likes_count(post)
    post.likes.joins(:user).where(users: { is_deleted: false }).count
  end

  def active_bookmarks_count(post)
    post.bookmarks.joins(:user).where(users: { is_deleted: false }).count
  end

  def active_comments_count(post)
    post.comments.joins(:user).where(users: { is_deleted: false }).count
  end
  
  # 未確認の通知を検索するメソッド
  def unread_notifications?
    current_user.passive_notifications.where(checked: false).exists?
  end

end
