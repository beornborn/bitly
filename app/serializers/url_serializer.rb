class UrlSerializer < ActiveModel::Serializer
  attributes :id, :original_url, :short_url, :updated_at

  has_many :clicks
end
