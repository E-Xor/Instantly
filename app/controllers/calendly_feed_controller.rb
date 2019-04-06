class CalendlyFeedController < ApplicationController
	def index
		Rails.logger.debug "MAKSIM Index hit"
		Rails.logger.debug "MAKSIM API Key: #{SETTINGS[:calendly_api_key]}"

    header = {
      "X-TOKEN" => SETTINGS[:calendly_api_key],
      "Content-Type"  => "application/json"
    }

    response = RestClient.get("#{SETTINGS[:calendly_api_url]}/echo", headers=header)
    @calanedly_echo = JSON.parse(response)

    response = RestClient.get("#{SETTINGS[:calendly_api_url]}/users/me/event_types", headers=header)
    @calanedly_event_types = JSON.parse(response)

    response = RestClient.get("#{SETTINGS[:calendly_api_url]}/users/me", headers=header)
    @calanedly_me = JSON.parse(response)

    response = RestClient.get("#{SETTINGS[:calendly_api_url]}/users/me/events", headers=header)
  end
end
