# frozen_string_literal: true

require 'faraday'
class Horoshop
  # Module for check connection
  module Connection
    ERROR = { status: 'HTTP_ERROR', message: 'UNKNOWN SERVER ERROR' }.freeze

    def post(instance:, url:, body:)
      connection(instance).post(url, body)
    rescue Faraday::Error => e
      error_status = e.response[:status]
      error_body = e.response&.dig(:body)
      if error_status.between?(500, 599)
        ERROR
      else
        { status: error_body['status'], message: error_body['response']['message'] }
      end
    end

    def connection(instance)
      @connection ||= Faraday.new(url: instance.url) do |faraday|
        faraday.request :json
        faraday.response :raise_error
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
