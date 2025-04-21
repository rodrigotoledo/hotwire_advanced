class Comment < ApplicationRecord
  belongs_to :user
  validates :content, :author, presence: true
  after_create_commit do
    broadcast_update_to [ user.id, "comments" ], target: "comments", partial: "comments/table_of_comments", locals: { comments: user.comments.order(created_at: :desc) }
    broadcast_update_to "total_of_comments", target: "total_of_comments", partial: "comments/total_of_comments"
  end
  after_update_commit do
    broadcast_update_to [ user.id, "comments" ], target: "comment_#{id}", partial: "comments/comment", locals: { comment: self }
    broadcast_update_to "total_of_comments", target: "total_of_comments", partial: "comments/total_of_comments"
  end
  after_destroy_commit do
    broadcast_remove_to [ user.id, "comments" ], target: "comment_#{id}"
    broadcast_update_to "total_of_comments", target: "total_of_comments", partial: "comments/total_of_comments"
  end
end
