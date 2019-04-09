require 'rails_helper'

RSpec.describe CalendlyFeedController, type: :controller do
  render_views

  describe 'GET index' do
    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'responds with 200' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'responds with html' do
      get :index
      expect(response.content_type).to eq('text/html')
    end

    it 'has user name' do
      get :index
      expect(response.body).to include('Maksim Sundukov')
    end

    it 'has title' do
      get :index
      expect(response.body).to include('Instantly')
    end

    it 'has an event' do
      Event.create!(
        uuid:               'BBBBBBBBBB',
        start_time:         '2019-04-09T14:30:00'.to_datetime,
        end_time:           '2019-04-09T14:45:00'.to_datetime, 
        invitee_email:      'test@example.com',
        invitee_name:       '',
        invitee_event_name: 'Test Event One',
        all_attributes:     ''
      )
      get :index
      expect(response.body).to include('Test Event One')
      expect(response.body).to include('test@example.com')
      expect(response.body).to include('April 09, 2019 at  2:30pm')
      expect(response.body).to include('for 15 minutes')
    end

  end

  describe 'POST webhook_catch' do
    it 'catches creation' do
      expect(Event.count).to be(0)
      post :webhook_catch, params: JSON.parse('
{
  "event": "invitee.created",
  "time": "2019-04-07T15:59:33Z",
  "payload": {
    "event_type": {
      "uuid": "CDCF4WPPVFDMVHUX",
      "kind": "One-on-One",
      "slug": "30min",
      "name": "30 Minute Meeting",
      "duration": 30,
      "owner": {
        "type": "users",
        "uuid": "EECFHWPVSB5FJE7I"
      }
    },
    "event": {
      "uuid": "AEG2D4PZKYNEZC2Q",
      "assigned_to": [
        "Maksim Sundukov"
      ],
      "extended_assigned_to": [
        {
          "name": "Maksim Sundukov",
          "email": "test1@example.com",
          "primary": true
        }
      ],
      "start_time": "2019-04-08T09:30:00-04:00",
      "start_time_pretty": "09:30am - Monday, April 8, 2019",
      "invitee_start_time": "2019-04-08T09:30:00-04:00",
      "invitee_start_time_pretty": "09:30am - Monday, April 8, 2019",
      "end_time": "2019-04-08T10:00:00-04:00",
      "end_time_pretty": "10:00am - Monday, April 8, 2019",
      "invitee_end_time": "2019-04-08T10:00:00-04:00",
      "invitee_end_time_pretty": "10:00am - Monday, April 8, 2019",
      "created_at": "2019-04-07T11:59:33-04:00",
      "location": null,
      "canceled": false,
      "canceler_name": null,
      "cancel_reason": null,
      "canceled_at": null
    },
    "invitee": {
      "uuid": "FACYK3QRE5TF4UJ6",
      "first_name": null,
      "last_name": null,
      "name": "Calendly Test Two",
      "email": "test2@example.com",
      "text_reminder_number": null,
      "timezone": "America/New_York",
      "created_at": "2019-04-07T11:59:33-04:00",
      "is_reschedule": false,
      "payments": [],
      "canceled": false,
      "canceler_name": null,
      "cancel_reason": null,
      "canceled_at": null
    },
    "questions_and_answers": [],
    "questions_and_responses": {},
    "tracking": {
      "utm_campaign": null,
      "utm_source": null,
      "utm_medium": null,
      "utm_content": null,
      "utm_term": null,
      "salesforce_uuid": null
    },
    "old_event": null,
    "old_invitee": null,
    "new_event": null,
    "new_invitee": null
  }
}'), format: :json

      expect(response.content_type).to eq 'application/json'
      expect(response.body).to eq('{"success":true}')
      expect(Event.count).to eq(1)
      event = Event.find_by(uuid: 'AEG2D4PZKYNEZC2Q')
      expect(event.start_time.utc.to_s).to eq('2019-04-08 13:30:00 UTC')
      expect(event.end_time.utc.to_s).to eq('2019-04-08 14:00:00 UTC')
      expect(event.invitee_email).to eq('test2@example.com')
    end

    it 'catches nothing' do
      post :webhook_catch
      expect(response.content_type).to eq('application/json')
      expect(response.body).to eq('{"success":true}')
    end

    it 'catches wrong event' do
      post :webhook_catch, params: JSON.parse('{"event": "invitee.created","everything_else_is": "wrong"}'), format: :json
      expect(response.content_type).to eq('application/json')
      expect(response.body).to eq('{"success":false}')
    end
  end
end
