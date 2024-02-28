# frozen_string_literal: true

require_relative 'connection'

module Horoshop
  # base class for all methods used in others classes
  class Base
    include Connection
    attr_reader :horoshop

    # @param {Horoshop::client}
    def initialize(horoshop)
      @horoshop = horoshop
    end
  end
end
