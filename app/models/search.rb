class Search

  CONDITIONS = %w(Questions Answers Comments Users Anything)

  def self.query(query, condition)
    return [] unless CONDITIONS.include?(condition)
    escaped_query = Riddle::Query.escape(query)
    if condition == 'Anything'
      ThinkingSphinx.search escaped_query
    else
      ThinkingSphinx.search escaped_query, classes: [condition.singularize.classify.constantize]
    end
  end
end
