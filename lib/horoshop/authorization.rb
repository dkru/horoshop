# frozen_string_literal: true

require_relative 'connection'

module Horoshop
  # Class for user authorization
  class Authorization < ::Horoshop::Base
    AUTH_URL = '/api/auth/'
    EXPIRATION_TIME = 600

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
