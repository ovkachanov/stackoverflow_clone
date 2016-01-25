class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment_body, :user_id, :created_at, :updated_at
end
