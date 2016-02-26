# onena

## Description

Ruby cli tool to reconcile [Tock](https://github.com/18F/tock) and [Float](https://www.float.com/) data.

Onena will return possible matches between Tock and Float users, clients,
projects, and project/client combinations.  Exact matches are excluded.

Possible matches are returned with [Levenshtein
distance](https://en.wikipedia.org/wiki/Levenshtein_distance) and [White
similarity](http://www.catalysoft.com/articles/StrikeAMatch.html).

## Usage

To get started, you'll need Tock and [Float API](https://github.com/floatschedule/api) keys.

For flexibility, all possible matches are returned as JSON, and filtering is done by a
separate tool.  The examples below using [jq](https://stedolan.github.io/jq/)
to filter the results.

### Configuration

Set the Tock API key as the environment variable `TOCK_API_KEY` and the Float
API Key as `FLOAT_API_KEY`, or pass the keys as arguments.  You may also set
`TOCK_API_ENDPOINT` to override the default endpoint,
`https://tock.18f.gov/api/`.

```shell
$ export TOCK_API_ENDPOINT=http://192.168.33.10/api
$ export TOCK_API_KEY=...
$ export FLOAT_API_KEY=...
```

### Get possible project matches with a Levenshtein distance of 4 or less

```shell
$ onena | jq 'select(.type == "project" and .distance <= 4)'
{
  "float": "First Proj",
  "tock": "First Project",
  "distance": 3,
  "similarity": 0.8235294117647058,
  "type": "project"
}
```

### Get possible user matches with a White similarity of 0.8 or greater

```shell
$ onena | jq 'select(.type == "user" and .similarity >= 0.8)'
{
  "float": "Christian Warden",
  "tock": "Christian G. Warden",
  "distance": 3,
  "similarity": 0.9629629629629629,
  "type": "user"
}
```

### Get possible client matches with a Levenshtein distance of 3 or less
```shell
$ onena | jq 'select(.type == "client" and .distance <= 3)'
{
  "float": "Acme!",
  "tock": "Acme",
  "distance": 1,
  "similarity": 0.8571428571428571,
  "type": "client"
}
```

### Get possible project->client matches with a Levenshtein distance of 8 or less

```shell
$ onena | jq 'select(.type == "project-client" and .distance <= 8)'
{
  "float": "First Proj -> Acme!",
  "tock": "First Project -> Acme",
  "distance": 4,
  "similarity": 0.8461538461538461,
  "type": "project-client"
}
```

### Library Usage

Onena can also be used a ruby library.

```ruby
require 'onena'

client = Onena::Client.new(tock_api_key: 'tock key ...', float_api_key: 'float key ...', tock_api_endpoint: 'http://192.168.33.10/api')

# if you set the 'TOCK_API_KEY' and 'FLOAT_API_KEY' env vars, just use:
client = Onena::Client.new

client.possible_client_matches.select { |match| match[:distance] <= 4 }
 => [{:float=>"Acme!", :tock=>"Acme", :distance=>1, :similarity=>0.8571428571428571}]
client.possible_project_matches.select { |match| match[:distance] <= 4 }
 => [{:float=>"First Proj", :tock=>"First Project", :distance=>3, :similarity=>0.8235294117647058}]
client.possible_project_client_matches.select { |match| match[:distance] <= 4 }
 => [{:float=>"First Proj -> Acme!", :tock=>"First Project -> Acme", :distance=>4, :similarity=>0.8461538461538461}]
client.possible_user_matches.select { |match| match[:distance] <= 4 }
 => [{:float=>"Christian Warden", :tock=>"Christian G. Warden", :distance=>3, :similarity=>0.9629629629629629}]
```

## Install

From the command-line:

```shell
$ gem install onena
```

or in your Gemfile:

```ruby
gem 'onena', github: 'cwarden/onena'
```

## History

This tool was developed by [Christian G. Warden](https://github.com/cwarden) as
a [micro-purchase by 18F](https://micropurchase.18f.gov/auctions/11).  For
consistency with other 18F projects (and because the author has almost nil
experience with Ruby) the [samwise](https://github.com/18F/samwise) project by
[Alan deLevie](https://github.com/adelevie) was used as a template for the
application structure.

## Public Domain

This project is in the worldwide [public domain](LICENSE.md).

> This project is in the public domain within the United States, and copyright
> and related rights in the work worldwide are waived through the [CC0 1.0 > Universal public domain > dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication.
> By submitting a pull request, you are agreeing to comply with this waiver of
> copyright interest.
