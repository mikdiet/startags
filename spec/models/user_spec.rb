require 'spec_helper'

describe User do
  describe '.from_omniauth' do
    let(:oauth){ {
        'provider' => 'github',
        'uid' => '123123',
        'info' => {
          'email' => 'test@test.com',
          'name' => 'Test User'
        },
        'credentials' => {
          'token' => 'abc123456'
        }
    } }

    subject{ User.from_omniauth(oauth) }

    context 'for existed user' do
      let!(:user){ create :user, uid: '123123' }
      it{ is_expected.to eq user }

      it 'has new values from oauth' do
        expect( subject.name ).to eq 'Test User'
        expect( subject.email ).to eq 'test@test.com'
        expect( subject.token ).to eq 'abc123456'
      end
    end

    context 'for new user' do
      it{ is_expected.to be_persisted }

      it 'has new values from oauth' do
        expect( subject.uid ).to eq '123123'
        expect( subject.name ).to eq 'Test User'
        expect( subject.email ).to eq 'test@test.com'
        expect( subject.token ).to eq 'abc123456'
      end
    end
  end
end
