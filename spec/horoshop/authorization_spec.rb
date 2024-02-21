# frozen_string_literal: true

require 'spec_helper'

describe Horoshop::Authorization do
  subject { described_class.new(instance) }

  let(:instance) { instance_double('Instance', username: 'user123', password: 'pass123', url: 'http://api.horosop.com') }

  before do
    allow(instance).to receive(:token=)
    allow(instance).to receive(:expiration_timestamp=)
    allow(Time).to receive(:now).and_return(Time.parse('2024-02-21 12:42:59 +0200'))
  end

  after { subject.authorize }

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

      it { expect(instance).to receive(:token=).with('123qwe4') }
      it { expect(instance).to receive(:expiration_timestamp=).with(Time.parse('2024-02-21 12:42:59 +0200') + 600) }
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

      it { expect(instance).not_to receive(:token=) }
      it { expect(instance).not_to receive(:expiration_timestamp=) }
      it { expect(subject.authorize).to be_a(Object) }
    end
  end
end
