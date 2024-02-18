# frozen_string_literal: true

require 'faraday'

# Base class used to store data about authentication
class Horoshop
  ERROR = { server_error: { status: 'HTTP_ERROR', message: 'UNKNOWN SERVER ERROR' } }.freeze
  EXPIRATION_TIME = Time.now + 600
  def initialize(url:, username:, password:)
    @url = url
    @username = username
    @password = password
    @token = nil
    @expiration_timestamp = nil
  end

  def setup_connection
    @conn = Faraday.new(url: @url) do |faraday|
      faraday.request :json
      faraday.response :raise_error
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
    authorize
  end

  private

  attr_reader :url, :username, :password, :token, :expiration_timestamp

  def authorize
    response = @conn.post(url, { username: @username, password: @password })
    if response.body['status'] == 'OK'
      @token = response.body['token']
      @expiration_timestamp = EXPIRATION_TIME
      true
    end
  rescue Faraday::Error => e
    handle_faraday_error(e)
  end

  def handle_faraday_error(error)
    error_response = error.response
    error_status = error_response[:status]
    error_body = error_response[:body]
    error_status.between?(500, 599) ? ERROR[:server_error] : error_body
  end
end
