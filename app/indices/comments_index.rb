ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes comment_body, sortable: true
  indexes user_id
  has created_at, updated_at
end
