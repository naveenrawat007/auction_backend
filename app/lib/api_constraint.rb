class ApiConstraint
	def initialize(options)
		@version = options[:version]
		@default = options[:default]
	end

	def matches?(req)
		@default || req.headers['Accept'].include?("application/vnd.auction_backend.v#{@version}") && (req.headers['Content-Type'].include?("application/json") || req.headers['Content-Type'].include?("multipart/form-data"))
	end
end
