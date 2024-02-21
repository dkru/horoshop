# frozen_string_literal: true

require 'spec_helper'

describe Horoshop::Authorization do
  let(:instance) { double('Instance', username: 'user', password: 'pass', url: 'http://api.horosop.com') }

  before do
    allow(instance).to receive(:token=)
    allow(instance).to receive(:expiration_timestamp=)
    allow(Time).to receive(:now).and_return(Time.now)
  end

  subject(:authorization) { described_class.new(instance) }

  describe '#authorize' do
    context 'when authorization is successful' do
      let(:successful_response) do
        {
          body: { 'status' => 'OK', 'response' => { 'token' => 'valid_token' } }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        }
      end

      before do
        stub_request(:post, 'http://api.horosop.com/api/auth/')
          .with(body: { login: 'user', password: 'pass' })
          .to_return(successful_response)
      end

      it 'sets the token and expiration_timestamp on the instance' do
        authorization.authorize
        expect(instance).to have_received(:token=).with('valid_token')
        expect(instance).to have_received(:expiration_timestamp=).with(an_instance_of(Time))
      end
    end

    context 'when authorization fails' do
      before do
        stub_request(:post, 'http://api.horosop.com/api/auth/')
          .with(body: { login: 'user', password: 'pass' })
          .to_return(
            status: 200,
            body: { 'status' => 'ERROR', 'response' => { 'message' => 'some_message' } }.to_json
          )
      end

      it 'does not set the token and expiration_timestamp on the instance' do
        response = authorization.authorize
        expect(JSON.parse(response)).to include('status' => 'ERROR')
        expect(JSON.parse(response)).to include('response' => { 'message' => 'some_message' })
        expect(instance).not_to have_received(:token=)
        expect(instance).not_to have_received(:expiration_timestamp=)
      end
    end
  end
end
