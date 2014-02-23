class List
  include Mongoid::Document
  field :list_id, type: String
  field :name, type: String
  field :description, type: String
end
