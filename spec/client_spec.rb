require 'spec_helper'
require 'onena'

describe Onena::Client, :vcr => { :cassette_name => 'Onena::Client', :record => :new_episodes } do
	let(:tock_api_endpoint) { ENV['TOCK_API_ENDPOINT'] || 'http://192.168.33.10/api' }
	let(:tock_api_key)      { ENV['TOCK_API_KEY'] }
	let(:float_api_key)     { ENV['FLOAT_API_KEY'] || 'TEST_KEY' }
	let(:client)            { Onena::Client.new(tock_api_key: tock_api_key, tock_api_endpoint: tock_api_endpoint, float_api_key: float_api_key) }

	context '#tock_user_names' do
		it 'should return an Array' do
			expect(client.tock_user_names).to be_a(Array)
		end
		it 'should extract people names' do
			users = client.tock_user_names
			expect(users).to include('Christian G. Warden')
		end
	end

	context '#tock_project_names' do
		it 'should return an Array' do
			expect(client.tock_project_names).to be_a(Array)
		end
		it 'should extract project names' do
			projects = client.tock_project_names
			expect(projects).to include('First Project')
		end
	end

	context '#tock_project_client_names' do
		it 'should return an Array' do
			expect(client.tock_project_client_names).to be_a(Array)
		end
		it 'should extract project and client names' do
			projects = client.tock_project_client_names
			expect(projects).to include('First Project -> Acme')
		end
	end

	context '#tock_client_names' do
		it 'should return an Array' do
			expect(client.tock_client_names).to be_a(Array)
		end
		it 'should return unique clients' do
			clients = client.tock_client_names
			expect(clients.length).to eq(33)
		end
		it 'should extract client names' do
			clients = client.tock_client_names
			expect(clients).to include('Acme')
		end
	end

	context '#float_user_names' do
		it 'should return an Array' do
			expect(client.float_user_names).to be_a(Array)
		end
		it 'should extract people names' do
			users = client.float_user_names
			expect(users).to include('Christian Warden')
		end
	end

	context '#float_project_names' do
		it 'should return an Array' do
			expect(client.float_project_names).to be_a(Array)
		end
		it 'should extract people names' do
			projects = client.float_project_names
			expect(projects).to include('First Proj')
		end
	end

	context '#float_project_client_names' do
		it 'should return an Array' do
			expect(client.float_project_client_names).to be_a(Array)
		end
		it 'should extract project and client names' do
			projects = client.float_project_client_names
			expect(projects).to include('First Proj -> Acme!')
		end
	end

	context '#float_client_names' do
		it 'should return an Array' do
			expect(client.float_client_names).to be_a(Array)
		end
		it 'should return unique clients' do
			clients = client.float_client_names
			expect(clients.length).to eq(3)
		end
		it 'should extract client names' do
			clients = client.float_client_names
			expect(clients).to include('Acme!')
		end
	end

	context '#tagged_possible_matches' do
		it 'should tag possible matches' do
			matches = client.tagged_possible_matches
			expect(matches[0][:type]).to eq(:user)
		end
		it 'should include levenshtein distance' do
			matches = client.tagged_possible_matches
			expect(matches.select { |match| match[:distance] <= 4 }).not_to be_empty
		end
		it 'should include white similarity' do
			matches = client.tagged_possible_matches
			expect(matches.select { |match| match[:similarity] >= 0.8 }).not_to be_empty
		end
	end
end
