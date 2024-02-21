# frozen_string_literal: true

require_relative 'connection'

class Horoshop
  # Class for user authorization
  class Authorization
    include Connection
    AUTH_URL = '/api/auth/'
    EXPIRATION_TIME = 600

    def initialize(instance)
      @instance = instance
    end

    def authorize
      response = post(instance: instance, url: AUTH_URL, body: body)
      return response.body unless response.body['status'] == 'OK'

      instance.token = response.body['response']['token']
      instance.expiration_timestamp = Time.now + EXPIRATION_TIME
      response.body
    end


    private

    attr_reader :instance

    def body
      { login: instance.username, password: instance.password }
    end
  end
end
