# frozen_string_literal: true

module Horoshop
  # import_residues to the horoshop
  class ImportResiduences < ::Horoshop::Base
    URL = 'api/catalog/importResidues/'
    STATUS_OK = 'OK'

    # @param {Hash}
    def call(body)
      body = post(horoshop: horoshop, url: URL, body: body, add_token: true)
      parse_response(body)
    end

    private

    def parse_response(body)
      log = body.dig('response', 'log')
      return [] unless log

      log.filter { |el| el['status'] != STATUS_OK }
    end
  end
end
