class EventsController < ApplicationController
  before_action :load_meetup_client

  def index
    @events = @meetup.events({group_id: 1355269, fields: "event_hosts"})["results"]
  end

  def show
    @event = JSON.parse(
      `curl https://api.meetup.com/#{params["group"]}/events/#{params["id"]}?key=#{Rails.application.secrets.meetup_api_key}&sign=true`
    )
    render "event"
  end

  private

  def load_meetup_client
    @meetup = MeetupApi.new
  end
end
