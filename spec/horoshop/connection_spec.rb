# frozen_string_literal: true

require 'spec_helper'

describe Horoshop::Connection do
  subject { object.new('http://api.horosop.com') }

  let(:object) do
    Class.new do
      include Horoshop::Connection
      attr_accessor :url

      def initialize(url)
        @url = url
      end
    end
  end

  describe '#post' do
    let(:url) { '/api/test' }
    let(:body) { { key: 'value' } }

    context 'when request is successful' do
      before do
        stub_request(:post, "http://api.horosop.com#{url}")
          .to_return(
            status: 200,
            body: { 'status' => 'OK', 'response' => { 'token' => '123qwe4' } }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns a success response' do
        response = subject.post(horoshop: subject, url: url, body: body)
        expect(response).to include('status' => 'OK')
      end
    end

    context 'when a server error occurs' do
      before do
        stub_request(:post, "http://api.horosop.com#{url}")
          .to_return(status: 500, body: nil, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a server error message' do
        response = subject.post(horoshop: subject, url: url, body: body)
        expect(response).to eq(Horoshop::Connection::ERROR)
      end
    end

    context 'when a server return non json object' do
      before do
        stub_request(:post, "http://api.horosop.com#{url}")
          .to_return(status: 302, body: '<html></html>', headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a server error message' do
        response = subject.post(horoshop: subject, url: url, body: body)
        expect(response).to eq(Horoshop::Connection::ERROR)
      end
    end
  end
end
