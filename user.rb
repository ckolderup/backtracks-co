class User
  include DataMapper::Resource
  property :id,          Serial
  property :nickname,    String
  property :email,       String
  property :lastfm_user, String
  property :created_at,  DateTime
  property :updated_at,  DateTime
end
