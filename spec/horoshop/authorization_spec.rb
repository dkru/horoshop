# frozen_string_literal: true

require 'spec_helper'

describe Horoshop::Authorization do
  subject(:auth) { described_class.new(instance) }

  let(:instance) { instance_double('Instance', username: 'user123', password: 'pass123', url: 'http://api.horosop.com') }

  before do
    allow(instance).to receive(:token=)
    allow(instance).to receive(:expiration_timestamp=)
    allow(Time).to receive(:now).and_return(Time.parse('2024-02-21 12:42:59 +0200'))
  end

  describe '#authorize' do
    context 'when authorization is successful' do
      let(:successful_response) do
        {
          body: { 'status' => 'OK', 'response' => { 'token' => '123qwe4' } }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        }
      end

      before do
        stub_request(:post, 'http://api.horosop.com/api/auth/')
          .with(body: { login: 'user123', password: 'pass123' })
          .to_return(successful_response)
      end

      it 'sets the token and expiration_timestamp on the instance' do
        expect(instance).to receive(:token=).with('123qwe4')
        expect(instance).to receive(:expiration_timestamp=).with(Time.now + 600)
        auth.authorize
      end
    end

    context 'when authorization fails' do
      before do
        stub_request(:post, 'http://api.horosop.com/api/auth/')
          .with(body: { login: 'user123', password: 'pass123' })
          .to_return(
            status: 200,
            body: { 'status' => 'ERROR', 'response' => { 'message' => 'error message' } }.to_json
          )
      end

      it 'does not set the token and expiration_timestamp on the instance' do
        expect(instance).not_to receive(:token=)
        expect(instance).not_to receive(:expiration_timestamp=)
        expect(JSON.parse(auth.authorize)).to include('status')
        expect(JSON.parse(auth.authorize)).to include('response' => match('message' => 'error message'))
      end
    end
  end
end
