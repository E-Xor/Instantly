class CalendlyFeedController < ApplicationController
  protect_from_forgery except: :webhook_catch
  def index
    header = {
      'X-TOKEN' => SETTINGS[:calendly_api_key],
      'Content-Type'  => 'application/json'
    }

    # Echo
    # response = RestClient.get("#{SETTINGS[:calendly_api_url]}/echo", headers=header)
    # @calanedly_echo = JSON.parse(response)

    response = RestClient.get("#{SETTINGS[:calendly_api_url]}/users/me", headers=header)
    @me = JSON.parse(response)

    # Event types
    # response = RestClient.get("#{SETTINGS[:calendly_api_url]}/users/me/event_types", headers=header)
    # @event_types = JSON.parse(response)

    # Only future events
    # response = RestClient.get("#{SETTINGS[:calendly_api_url]}/users/me/events", headers=header)
    # {"data"=>[{"type"=>"events", "id"=>"AAD7B3L2H4JE5WWI", "attributes"=>{"uuid"=>"AAD7B3L2H4JE5WWI", "start_time"=>"2019-04-08T14:00:00Z", "end_time"=>"2019-04-08T14:15:00Z", "duration"=>15, "created_at"=>"2019-04-07T01:20:43Z", "canceled"=>false, "invitees_count"=>1}, "relationships"=>{"event_type"=>{"data"=>{"type"=>"event_types", "id"=>"FGEH7WPJSDFNRHUM"}}, "invitee"=>{"data"=>{"type"=>"invitees", "id"=>"GFH5J6SI45GJI3QU"}}}}], "meta"=>{"total_count"=>1, "total_pages"=>1, "current_page"=>1, "prev_page"=>nil, "next_page"=>nil}} 
    # @events = JSON.parse(response)['data'] 

    @events = Event.all.order(start_time: :desc)
  end

  def webhook_catch
    Rails.logger.info "Webhook catch"

    if params['event'] == 'invitee.created'
      invitee_name = params['payload']['invitee']['first_name'].to_s + ' ' + params['payload']['invitee']['last_name'].to_s # con be nil, to_s ensures it's still a string

      Event.create!(
        uuid:               params['payload']['event']['uuid'],
        start_time:         params['payload']['event']['start_time'].to_datetime,
        end_time:           params['payload']['event']['end_time'].to_datetime, 
        invitee_email:      params['payload']['invitee']['email'],
        invitee_name:       invitee_name,
        invitee_event_name: params['payload']['invitee']['name'],
        all_attributes:     params.to_s
      )
    end

    render json: {success: true}
  rescue => e
    render json: {success: false}
    raise
  end

end
