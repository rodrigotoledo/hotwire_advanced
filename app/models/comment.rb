class Comment < ApplicationRecord
  validates :content, presence: true
  after_create_commit { broadcast_append_to "comments" }
  after_update_commit { broadcast_update_to "comments", target: "comment_#{self.id}", partial: "comments/comment", locals: { comment: self } }
  after_destroy_commit { broadcast_remove_to "comments", target: "comment_#{self.id}" }
end
