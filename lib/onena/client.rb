require 'curb'
require 'json'

module Onena
	class Client
		def initialize(tock_api_key: nil, float_api_key: nil, tock_api_endpoint: nil)
			@tock_api_key  = tock_api_key  || ENV['TOCK_API_KEY']
			@float_api_key = float_api_key || ENV['FLOAT_API_KEY']
			@tock_api_endpoint = tock_api_endpoint || ENV['TOCK_API_ENDPOINT'] || Onena::Protocol::TOCK_API_BASE_URL
			fail Onena::Error::ArgumentMissing, 'Float API key is missing' if @float_api_key.nil?
		end

		def float_user_names
			float_users = get_float_users
			float_users['people'].map { |user| user['name'] }
		end

		def tock_user_names
			tock_users = get_tock_users
			tock_users['results'].map { |user| [user['first_name'], user['last_name']].join(' ').strip }
		end

		def float_project_names
			float_projects = get_float_projects
			float_projects['projects'].map { |project| project['project_name'] }
		end

		def tock_project_names
			tock_projects = get_tock_projects
			tock_projects['results'].map { |project| project['name'] }
		end

		def float_client_names
			float_projects = get_float_projects
			clients = float_projects['projects'].map { |project| project['client_name'] }
			clients.uniq.compact
		end

		def tock_client_names
			tock_projects = get_tock_projects
			clients = tock_projects['results'].map { |project| project['client'] }
			clients.uniq
		end

		def float_project_client_names
			float_projects = get_float_projects
			project_clients = float_projects['projects'].map { |project| "#{project['project_name']} -> #{project['client_name']}" }
			project_clients.uniq.compact
		end

		def tock_project_client_names
			tock_projects = get_tock_projects
			project_clients = tock_projects['results'].map { |project| "#{project['name']} -> #{project['client']}" }
			project_clients.uniq
		end

		def possible_user_matches
			Onena::Util.matches(tock_list: tock_user_names, float_list: float_user_names)
		end

		def possible_project_matches
			Onena::Util.matches(tock_list: tock_project_names, float_list: float_project_names)
		end

		def possible_client_matches
			Onena::Util.matches(tock_list: tock_client_names, float_list: float_client_names)
		end

		def possible_project_client_matches
			Onena::Util.matches(tock_list: tock_project_client_names, float_list: float_project_client_names)
		end

		def tagged_possible_matches
			[tag_matches(matches: possible_user_matches, type: :user),
			tag_matches(matches: possible_project_matches, type: :project),
			tag_matches(matches: possible_client_matches, type: :client),
			tag_matches(matches: possible_project_client_matches, type: :"project-client")]
				.flatten
				.compact
		end

		def print_possible_matches
			tagged_possible_matches.each { |match| $stdout.puts match.to_json }
		end

		private

		def get_float_users
			response = fetch_float_users
			JSON.parse(response.body_str)
		end

		def get_tock_users
			response = fetch_tock_users
			JSON.parse(response.body_str)
		end

		def get_float_projects
			response = fetch_float_projects
			JSON.parse(response.body_str)
		end

		def get_tock_projects
			response = fetch_tock_projects
			JSON.parse(response.body_str)
		end

		def tock_request(url)
			Curl.get(url) do |http|
				# TODO: Confirm how authentication is done against production
				# endpoint, https://tock.18f.gov/api/
				http.headers['Cookie'] = '_oauth2_proxy=' + @tock_api_key unless @tock_api_key.nil?
			end
		end

		def fetch_tock_users
			url = Onena::Protocol.tock_users_url(endpoint: @tock_api_endpoint)
			tock_request(url)
		end

		def fetch_float_users
			url = Onena::Protocol.float_users_url
			Curl.get(url) do |http|
				 http.headers['Authorization'] = @float_api_key
			end
		end

		def fetch_tock_projects
			url = Onena::Protocol.tock_projects_url(endpoint: @tock_api_endpoint)
			tock_request(url)
		end

		def fetch_float_projects
			url = Onena::Protocol.float_projects_url
			Curl.get(url) do |http|
				 http.headers['Authorization'] = @float_api_key
			end
		end

		def tag_matches(matches: [], type: nil)
			matches.map { |match| match.merge(type: type) }
		end

	end
end
