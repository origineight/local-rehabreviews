require 'elasticsearch/model'

class City < ActiveRecord::Base
  # External resources definitions
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  #default_scope
  default_scope{order(name: :asc)}

  #Associations
  belongs_to :state

  #Validations
  validates :name, presence: true
  validates :name, uniqueness: { scope: [:state_id]}

  #Callbacks
  before_validation :format_attributes

  #Elasticsearch Configuration
  settings :analysis => {:analyzer => {:case_insensitive_sort => {:tokenizer => "keyword", :filter => ["lowercase"]}}} do
    mapping do
      indexes :name, type: 'string', :fields => {"lower_case_sort" => {"type" => "string", "analyzer" => "case_insensitive_sort"}, "first_letter" => {"type" => "string", "index" => "not_analyzed"}}
      indexes :state_str, type: 'string', :fields => {"lower_case_sort" => {"type" => "string", "analyzer" => "case_insensitive_sort"}}
    end
  end

  #Methods
  def as_indexed_json(options={})
    as_json(
      only: [:name],
      include: {state: { only: [:name]}})
  end

  def state_str
    self.state.name
  end

  private
  def format_attributes
    self.name = self.name.downcase.titleize
  end
end
