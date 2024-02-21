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
      responce = post(instance: instance, url: AUTH_URL, body: body)
      return responce.body unless responce.body['status'] == 'OK'

      instance.token = responce.body['response']['token']
      instance.expiration_timestamp = Time.now + EXPIRATION_TIME
    end


    private

    attr_reader :instance

    def body
      { login: instance.username, password: instance.password }
    end
  end
end
