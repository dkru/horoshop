# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

describe Horoshop do
  let(:url) { 'http://api.horosop.com' }
  let(:username) { 'valid_user' }
  let(:password) { 'valid_password' }
  let(:params) do
    { url: url, username: username, password: password }
  end
  subject(:horoshop) { described_class.new(params) }

  describe '#initialize' do
    context 'when all parameters passed' do
      it { is_expected { subject }.to be_a Horoshop }
    end

    context 'when parameters' do
      let(:params) { { url: url } }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end

  describe '#token_valid?' do
    context 'when token is present and not expired' do
      before do
        horoshop.token = 'some_token'
        horoshop.expiration_timestamp = Time.now - 400
      end

      it 'returns true' do
        expect(horoshop.token_valid?).to be true
      end
    end

    context 'when token is present but expired' do
      before do
        horoshop.token = 'some_token'
        horoshop.expiration_timestamp = Time.now + 700
      end

      it 'returns false' do
        expect(horoshop.token_valid?).to be false
      end
    end

    context 'when token is nil' do
      before do
        subject
        horoshop.token = nil
      end

      it 'returns false' do
        expect(horoshop.token_valid?).to be false
      end
    end
  end

  describe '#refresh_token!' do
    let(:authorization_instance) { instance_double(Horoshop::Authorization) }

    before do
      allow(Horoshop::Authorization).to receive(:new).with(horoshop).and_return(authorization_instance)
      allow(authorization_instance).to receive(:authorize)
    end

    it 'calls authorize on a new Horoshop::Authorization instance' do
      horoshop.refresh_token!
      expect(Horoshop::Authorization).to have_received(:new).with(horoshop)
      expect(authorization_instance).to have_received(:authorize)
    end

    context 'when authorize updates the token and expiration_timestamp' do
      let(:new_token) { 'new_token' }
      let(:new_expiration_timestamp) { Time.now + 600 }

      before do
        allow(authorization_instance).to receive(:authorize) do
          horoshop.token = new_token
          horoshop.expiration_timestamp = new_expiration_timestamp
        end
      end

      it 'updates the token and expiration_timestamp on the Horoshop instance' do
        expect { horoshop.refresh_token! }.to change(horoshop, :token).from(nil)
                                                                      .to(new_token)
                                                                      .and change(horoshop, :expiration_timestamp)
                                                                      .from(nil).to(new_expiration_timestamp)
      end
    end
  end
end
