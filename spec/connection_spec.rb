# frozen_string_literal: true

require 'spec_helper'

describe Horoshop::Connection do
  let(:object) do
    Class.new do
      include Horoshop::Connection
      attr_accessor :url

      def initialize(url)
        @url = url
      end
    end
  end

  subject(:connection_instance) { object.new('http://api.horosop.com') }

  describe '#post' do
    let(:url) { '/api/test' }
    let(:body) { { key: 'value' } }

    context 'when request is successful' do
      before do
        stub_request(:post, "http://api.horosop.com#{url}")
          .to_return(status: 200, body: '{"status":"OK","response": { "token": "some_token"} }')
      end

      it 'returns a success response' do
        response = connection_instance.post(instance: connection_instance, url: url, body: body)
        expect(JSON.parse(response.body)).to include('status' => 'OK', 'response' => { 'token' => 'some_token' })
      end
    end

    context 'when a server error occurs' do
      before do
        stub_request(:post, "http://api.horosop.com#{url}")
          .to_return(status: 500, body: '')
      end

      it 'returns a server error message' do
        response = connection_instance.post(instance: connection_instance, url: url, body: body)
        expect(response).to eq(Horoshop::Connection::ERROR)
      end
    end
  end
end
