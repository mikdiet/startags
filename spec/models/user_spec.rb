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

  describe '#repeat_collect_stars_async' do
    let(:user){ create :user }

    it 'does not perform sync when sync in progress' do
      user.update stars_updated_at: nil
      expect(user).to_not receive(:collect_stars_async)
      user.repeat_collect_stars_async
    end

    it 'does not perform sync when sync was recently' do
      user.update stars_updated_at: Time.current
      expect(user).to_not receive(:collect_stars_async)
      user.repeat_collect_stars_async
    end

    it 'performs sync' do
      user.update stars_updated_at: Time.current - 1.minute - User::STARS_SYNC_PERIOD
      expect(user).to receive(:collect_stars_async)
      user.repeat_collect_stars_async
    end
  end

  describe '#collect_stars_async' do
    let(:user){ create :user, stars_updated_at: Time.current }

    it 'nullifies stars_updated_at before star collecting' do
      user.collect_stars_async
      expect( user.stars_updated_at ).to be_nil
    end

    it 'runs worker' do
      expect( GetStarsWorker ).to receive(:perform_async).with(user.id)
      user.collect_stars_async
    end
  end

  describe 'creation' do
    let(:user){ build :user }

    it 'collects stars' do
      expect(user).to receive(:collect_stars_async)
      user.save
    end
  end

  describe 'saving' do
    let(:user){ create :user }

    it 'not collects stars' do
      expect(user).to_not receive(:collect_stars_async)
      user.save
    end
  end
end
