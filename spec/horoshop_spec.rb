# frozen_string_literal: true

require 'spec_helper'

describe Horoshop do
  describe '#initialize' do
    subject { described_class.new(params) }

    context 'when all parameters passed' do
      let(:params) do
        { url: 'http://api.horosop.com', username: 'user', password: '123456' }
      end

      it { is_expected.to be_a Horoshop }
    end

    context 'when parameters' do
      let(:params) { { url: 'http://api.horosop.com' } }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end
end
