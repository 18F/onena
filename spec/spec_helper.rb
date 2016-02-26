require 'rspec'
require 'onena/version'
require 'rspec/expectations'
require 'uri'
require 'vcr'

include Onena

RSpec::Matchers.define :be_a_valid_url do
	match do |actual|
		begin
			uri = URI.parse(actual)
			uri.kind_of?(URI::HTTP)
		rescue URI::InvalidURIError
			false
		end
	end

	failure_message do |actual|
		"expected that #{actual} would be a valid url"
	end
end

VCR.configure do |c|
	c.cassette_library_dir = 'spec/vcr'
	c.hook_into :webmock
	c.configure_rspec_metadata!
	c.filter_sensitive_data('<float_api_key>') { ENV['FLOAT_API_KEY'] }
	c.filter_sensitive_data('<tock_api_key>') { ENV['TOCK_API_KEY'] }
	c.before_http_request do
		# Work-around for Webmock bug
		# See https://github.com/vcr/vcr/issues/425
		Curl.reset
	end
end
