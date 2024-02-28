# frozen_string_literal: true

require 'faraday'
module Horoshop
  # Module for check connection
  module Connection
    ERROR = { 'status' => 'HTTP_ERROR', 'message' => 'UNKNOWN SERVER ERROR' }.freeze

    def post(horoshop:, url:, body:, add_token: false)
      mixin_token!(horoshop, body) if add_token
      connection(horoshop).post(url, body).body
    rescue Faraday::Error
      ERROR
    end

    def connection(horoshop)
      @connection ||= Faraday.new(url: horoshop.url) do |faraday|
        faraday.request :json
        faraday.response :raise_error
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def mixin_token!(horoshop, body)
      horoshop.refresh_token! unless horoshop.token_valid?
      body[:token] = horoshop.token
    end
  end
end
