class PagesController < ApplicationController

  def index
    @categories = Category.directory_sorted('rehabs').boostable.order(:name)
    q = {"filtered" => {"filter" => {"bool" => {"must" => [{"term" => {"featured" => true}}, {"term" => {"published" => true}}]}}}}
    @featured = Listing.search("query" => q).records.sort_by {rand}.slice(0,2)
    @recent_blogs = Post.order(created_at: :desc).limit(3)
  end

end
