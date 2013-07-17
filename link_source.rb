require_relative 'user'

class LinkSource
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :query_url, String

	has n, :users

	def get_link(query)
		query_url.gsub(/%q/, query)
	end
end