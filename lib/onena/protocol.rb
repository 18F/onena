module Onena
  module Protocol
	TOCK_API_BASE_URL   = 'https://tock.18f.gov/api/'
	FLOAT_API_BASE_URL  = 'https://api.floatschedule.com/api'
	FLOAT_API_VERSION   = 'v1'

	def self.tock_users_url(endpoint: nil)
		fail Onena::Error::ArgumentMissing, 'Tock endpoint is missing' if endpoint.nil?
		"#{endpoint}/users.json?page_size=100000"
	end

	def self.tock_projects_url(endpoint: nil)
		fail Onena::Error::ArgumentMissing, 'Tock endpoint is missing' if endpoint.nil?
		"#{endpoint}/projects.json?page_size=100000"
	end

	def self.float_users_url
		"#{FLOAT_API_BASE_URL}/#{FLOAT_API_VERSION}/people"
	end

	def self.float_projects_url
		"#{FLOAT_API_BASE_URL}/#{FLOAT_API_VERSION}/projects"
	end

  end
end
