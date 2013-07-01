class User
  include DataMapper::Resource
  property :id,          Serial
  property :uid,         String
  property :nickname,    String
  property :email,       String
  property :lastfm_user, String
end
