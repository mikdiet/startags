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

  describe '#collect_stars' do
    let!(:user){ create :user }
    let!(:previosly_deleted_star){ create :star, user: user, unstarred: true }
    let!(:existed_star){ create :star, user: user }
    let!(:previosly_starred_star){ create :star, user: user }
    let!(:new_star){ build :star, user: user }
    subject{ user.stars }

    before do
      client = double
      allow(user).to receive(:client).and_return client
      allow(client).to receive_message_chain(:starred, :map).and_return [previosly_deleted_star, existed_star, new_star]
      user.collect_stars
    end

    it 'has actual stars' do
      expect( subject.starred ).to include previosly_deleted_star, existed_star, new_star
    end

    it 'marks unstarred stars' do
      expect( subject.unstarred ).to include previosly_starred_star
    end

    it 'persists new stars' do
      expect( new_star ).to be_persisted
    end
  end
end
