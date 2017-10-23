class EventsController < ApplicationController
  before_action :load_meetup_client

  def index
    @events = @meetup.events({ group_id: 1355269, fields: 'event_hosts' })['results']
  end

  def show
    @event = JSON.parse(
      `curl https://api.meetup.com/#{params['group']}/events/#{params['id']}?key=#{Rails.application.secrets.meetup_api_key}&sign=true`
    )
    render 'event'
  end

  def rsvp
    if current_user.uid.present?
      JSON.parse(`curl -d 'key=#{Rails.application.secrets.meetup_api_key}&sign=true&event_id=#{params['event_id']}&rsvp=yes&member_id=#{current_user.uid}&opt_to_pay=true' https://api.meetup.com/2/rsvp/`)
    else
      JSON.parse(`curl -d 'key=#{Rails.application.secrets.meetup_api_key}&sign=true&event_id=#{params['event_id']}&rsvp=yes' https://api.meetup.com/2/rsvp/`)
    end
    redirect_to request.referer
  end

  private

  def load_meetup_client
    @meetup = MeetupApi.new
  end
end
