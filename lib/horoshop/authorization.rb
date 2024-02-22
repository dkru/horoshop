# frozen_string_literal: true

require_relative 'connection'

class Horoshop
  # Class for user authorization
  class Authorization
    include Connection
    AUTH_URL = '/api/auth/'
    EXPIRATION_TIME = 600

    def initialize(horoshop)
      @horoshop = horoshop
    end

    def authorize
      response = post(horoshop: horoshop, url: AUTH_URL, body: body)
      return response unless response['status'] == 'OK'

      horoshop.token = response.dig('response', 'token')
      horoshop.expiration_timestamp = Time.now + EXPIRATION_TIME
      response
    end

    private

    attr_reader :horoshop

    def body
      { login: horoshop.login, password: horoshop.password }
    end
  end
end
