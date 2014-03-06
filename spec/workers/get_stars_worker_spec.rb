require 'spec_helper'

describe GetStarsWorker do
  describe '#perform' do
    let!(:user){ create :user }
    before do
      allow_any_instance_of( User ).to receive(:collect_stars)
    end

    it 'collects stars' do
      expect_any_instance_of( User ).to receive(:collect_stars)
      GetStarsWorker.new.perform(user.id)
    end

    it 'sets stars_updated_at before star collecting' do
      GetStarsWorker.new.perform(user.id)
      expect( user.reload.stars_updated_at ).to_not be_nil
    end
  end
end
