# frozen_string_literal: true

# Base class used to store data about authentication
class Horoshop
  def initialize(url:, username:, password:)
    @url = url
    @username = username
    @password = password
    @token = nil
    @expiration_timestamp = nil
  end

  private

  attr_reader :url, :username, :password, :token, :expiration_timestamp
end
