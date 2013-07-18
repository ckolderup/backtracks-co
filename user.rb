require_relative 'link_source'

class User
  include DataMapper::Resource
  property :id,          Serial
  property :uid,         String
  property :nickname,    String
  property :email,       String
  property :lastfm_user, String
  property :active,      Boolean, default: true

  belongs_to :link_source, required: false

  before :save do |user|
    default_source = LinkSource.first
    if user.link_source.nil? && !default_source.nil?
      user.link_source = default_source
    end
  end
end
