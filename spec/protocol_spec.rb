require 'spec_helper'
require 'onena'

describe Onena::Protocol do
	let(:tock_endpoint) { 'http://192.168.33.10/api' }

	it 'should create the URLs for the Tock endpoint' do
		url = Onena::Protocol.tock_users_url(endpoint: tock_endpoint)
		expect(url).to be_a_valid_url

		url = Onena::Protocol.tock_projects_url(endpoint: tock_endpoint)
		expect(url).to be_a_valid_url
	end

	it 'should raise an ArgumentMissing error when arguments are missing' do
		expect do
			Onena::Protocol.tock_users_url
		end.to raise_error(Onena::Error::ArgumentMissing)

		expect do
			Onena::Protocol.tock_projects_url
		end.to raise_error(Onena::Error::ArgumentMissing)
	end

	it 'should create the URLs for the Float endpoint' do
		url = Onena::Protocol.float_users_url
		expect(url).to be_a_valid_url

		url = Onena::Protocol.float_projects_url
		expect(url).to be_a_valid_url
	end
end
