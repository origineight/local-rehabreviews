class SearchDecorator

  def self.decorate(params)
    if params[:directory].present?
      @directory = Directory.friendly.find(params[:directory].downcase)
    else
      @directory = Directory.friendly.find('rehabs')
    end
    @searcher = Searcher.new.make_search(params)
    @categories = Category.directory_sorted(@directory.slug).order(:name)
    return {
      'listings' => @searcher,
      'directory' => @directory,
      'categories' => @categories
    }
  end

end