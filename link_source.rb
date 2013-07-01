class LinkSource
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :query_url, String

	def get_link(query)
		query_url.gsub(/%q/, query)
	end
end