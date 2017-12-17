# frozen_string_literal: true

class API::Pivotal
  include HTTParty
  base_uri 'https://www.pivotaltracker.com/services/v5'
  logger Rails.logger

  class << self
    def story(story_id, **kwargs)
      _get("/stories/#{story_id}", **kwargs)
    end

    def my_people(project_id)
      _get('/my/people', query: { project_id: project_id })
    end

    def find_my_people(project_id, people_ids)
      people = my_people(project_id)
               .group_by { |person| person.dig(:person, :id) }
               .transform_values(&:first)

      people_ids.map { |id| people[id] }
    end

    def _get(*args, **kwargs)
      response = get(*args, headers: headers, **kwargs)

      JSON.parse(response.body, symbolize_names: true)
    end

    private

    def headers
      {
        'Content-Type' => 'application/json; charset=utf-8',
        'X-TrackerToken' => PIVOTAL_TOKEN
      }
    end
  end
end
