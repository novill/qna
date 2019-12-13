class SearchController < ApplicationController

  skip_authorization_check

  def show
    sanitized_query = ThinkingSphinx::Query.escape(params[:search_query].to_s)
    @result =
      if params[:search_class].blank?
        ThinkingSphinx.search(sanitized_query)
      else
        ThinkingSphinx.search(sanitized_query, classes: [params[:search_class].constantize])
      end
  end
end
