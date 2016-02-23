class Search

  CONDITIONS = %w(Questions Answers Comments Users Anything)

  def self.query(query, condition)
    if CONDITIONS.include?(condition)
      if condition == 'Anything'
        ThinkingSphinx.search query
      else
        ThinkingSphinx.search query, classes: [condition.singularize.classify.constantize]
      end
    else
      []
    end
  end
end
