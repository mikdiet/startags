require 'spec_helper'

describe Star do
  describe '.find_or_initialize_from_github' do
    let!(:repo){ create :repo, name: 'user/repo' }
    let!(:star){ create :star, repo: repo }

    it 'creates new repo' do
      data = double full_name: 'another/another', description: 'foo bar'
      expect{ Star.find_or_initialize_from_github(data) }.to change{ Repo.count }.by(1)
      expect( Repo.last.name ).to eq 'another/another'
      expect( Repo.last.description ).to eq 'foo bar'
    end

    it 'updates existed repo' do
      data = double full_name: 'user/repo', description: 'foo bar'
      expect{ Star.find_or_initialize_from_github(data) }.to_not change{ Repo.count }
      expect( repo.reload.description ).to eq 'foo bar'
    end

    it 'returns existed star' do
      data = double full_name: 'user/repo', description: 'foo bar'
      expect( Star.find_or_initialize_from_github(data) ).to eq star
    end

    it 'initializes new star' do
      data = double full_name: 'another/another', description: 'foo bar'
      expect( Star.find_or_initialize_from_github(data) ).to be_new_record
    end
  end
end
