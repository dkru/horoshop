# frozen_string_literal: true

require 'spec_helper'

describe Horoshop do
  let(:url) { 'http://api.horosop.com' }
  let(:username) { 'valid_user' }
  let(:password) { 'valid_password' }
  let(:invalid_username) { 'invalid_user' }
  let(:invalid_password) { 'invalid_password' }

  describe '#initialize' do
    subject { described_class.new(params) }

    context 'when all parameters passed' do
      let(:params) do
        { url: url, username: username, password: password }
      end

      it { is_expected.to be_a Horoshop }
    end

    context 'when parameters' do
      let(:params) { { url: url } }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end

  describe '#setup_connection and #authorize' do
    context 'with valid params' do
      before do
        stub_request(:post, url)
          .with(body: { username: username, password: password }.to_json)
          .to_return(status: 200, body: { status: 'OK', token: 'valid_token' }.to_json)
      end

      it 'authorize and set a token' do
        horoshop = Horoshop.new(url: url, username: username, password: password)
        horoshop.setup_connection
        expect(horoshop.send(:token)) == ('valid_token')
      end
    end

    context 'with invalid params' do
      before do
        stub_request(:post, url)
          .with(body: { username: invalid_username, password: invalid_password })
          .to_return(status: 401, body: { status: 'ERROR', message: 'Not authorized' }.to_json)
      end

      it 'does not authorize and does not set a token' do
        horoshop = Horoshop.new(url: url, username: invalid_username, password: invalid_password)
        expect { horoshop.setup_connection }.to_not raise_error
        expect(horoshop.send(:token)).to be_nil
      end
    end
  end

  describe 'error handling' do
    context 'when server returns 500 Internal Server Error' do
      before do
        stub_request(:post, url)
          .with(body: { username: username, password: password })
          .to_return(status: 500, body: { status: 'ERROR', message: 'Internal Server Error' }.to_json)
      end

      it 'captures the error and does not set a token' do
        horoshop = Horoshop.new(url: url, username: username, password: password)
        expect { horoshop.setup_connection }.to_not raise_error
        expect(horoshop.send(:token)).to be_nil
      end
    end
  end
end
