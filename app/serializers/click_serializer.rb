class ClickSerializer < ActiveModel::Serializer
  attributes :id, :url_id, :country, :browser, :platform, :created_at
end
