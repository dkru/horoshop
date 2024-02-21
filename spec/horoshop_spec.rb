# frozen_string_literal: true

require 'spec_helper'

describe Horoshop do
  subject(:horoshop) { described_class.new(params) }

  let(:url) { 'http://api.horosop.com' }
  let(:username) { 'user213' }
  let(:password) { 'pass' }
  let(:params) do
    { url: url, username: username, password: password }
  end

  describe '#initialize' do
    context 'when the parameters are not valid' do
      let(:params) { { url: url } }

      it { expect { horoshop }.to raise_error(ArgumentError) }
    end
  end

  describe '#token_valid?' do
    context 'when token is present and not expired' do
      before do
        horoshop.token = '2sgv458'
        horoshop.expiration_timestamp = Time.now - 400
      end

      it 'returns true' do
        expect(horoshop.token_valid?).to be true
      end
    end

    context 'when token is present but expired' do
      before do
        horoshop.token = '2sgv458'
        horoshop.expiration_timestamp = Time.now + 700
      end

      it 'returns false' do
        expect(horoshop.token_valid?).to be false
      end
    end

    context 'when token is nil' do
      before do
        horoshop
        horoshop.token = nil
      end

      it 'returns false' do
        expect(horoshop.token_valid?).to be false
      end
    end
  end

  describe '#refresh_token!' do
    let(:auth) { instance_double(Horoshop::Authorization) }

    before do
      allow(Horoshop::Authorization).to receive(:new).with(horoshop).and_return(auth)
      allow(auth).to receive(:authorize)
    end

    it 'calls authorize on a new Horoshop::Authorization instance' do
      horoshop.refresh_token!
      expect(Horoshop::Authorization).to have_received(:new).with(horoshop)
      expect(auth).to have_received(:authorize)
    end

    context 'when authorize updates the token and expiration_timestamp' do
      let(:new_token) { '123w45' }
      let(:new_expiration_timestamp) { Time.now }

      before do
        allow(auth).to receive(:authorize) do
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
