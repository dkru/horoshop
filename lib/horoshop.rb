# frozen_string_literal: true

require_relative 'horoshop/authorization'

module Horoshop
  # Base class used to store data about authentication
  class Client
    attr_accessor :url, :login, :password, :token, :expiration_timestamp

    def initialize(url:, login:, password:)
      @url = url
      @login = login
      @password = password
      @token = nil
      @expiration_timestamp = nil
    end

    def token_valid?
      return false if token.nil?

      expiration_timestamp < Time.now
    end

    def refresh_token!
      Horoshop::Authorization.new(self).authorize
    end
  end
end
