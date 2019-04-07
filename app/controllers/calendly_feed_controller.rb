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
    # {"data"=>[{"type"=>"events", "id"=>"AAD7B3L2H4JE5WWI", "attributes"=>{"uuid"=>"AAD7B3L2H4JE5WWI", "start_time"=>"2019-04-08T14:00:00Z", "end_time"=>"2019-04-08T14:15:00Z", "duration"=>15, "created_at"=>"2019-04-07T01:20:43Z", "canceled"=>false, "invitees_count"=>1}, "relationships"=>{"event_type"=>{"data"=>{"type"=>"event_types", "id"=>"FGEH7WPJSDFNRHUM"}}, "invitee"=>{"data"=>{"type"=>"invitees", "id"=>"GFH5J6SI45GJI3QU"}}}}], "meta"=>{"total_count"=>1, "total_pages"=>1, "current_page"=>1, "prev_page"=>nil, "next_page"=>nil}} 
  end
end
