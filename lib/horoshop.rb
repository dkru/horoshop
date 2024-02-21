# frozen_string_literal: true

require_relative 'horoshop/authorization'

# Base class used to store data about authentication
class Horoshop
  attr_accessor :url, :username, :password, :token, :expiration_timestamp

  def initialize(url:, username:, password:)
    @url = url
    @username = username
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
