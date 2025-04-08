class Comment < ApplicationRecord
  validates :content, presence: true
  after_create_commit do
    broadcast_update_to "comments_real_time", target: "comments", partial: "comments/table_of_comments", locals: {comments: Comment.order(created_at: :desc)}
    broadcast_update_to "total_of_comments", target: "total_of_comments", partial: "comments/total_of_comments"
  end
  after_update_commit do
    broadcast_update_to "comments", target: "comment_#{id}", partial: "comments/comment", locals: {comment: self}
    broadcast_update_to "total_of_comments", target: "total_of_comments", partial: "comments/total_of_comments"
  end
  after_destroy_commit do
    broadcast_remove_to "comments", target: "comment_#{id}"
    broadcast_update_to "total_of_comments", target: "total_of_comments", partial: "comments/total_of_comments"
  end
end
