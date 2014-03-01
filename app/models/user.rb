class User < ActiveRecord::Base
  has_many :stars, dependent: :destroy


  def self.from_omniauth(oauth)
    return unless oauth['provider'] == 'github'
    find_or_initialize_by(uid: oauth['uid']).tap do |user|
      user.name =  oauth['info']['name']
      user.email = oauth['info']['email']
      user.token = oauth['credentials']['token']
      user.save
    end
  end

  def collect_stars
    current_stars, new_stars = client.starred.map{ |data| stars.find_or_initialize_from_github(data) }.partition(&:persisted?)
    old_star_ids = stars.where.not(id: current_stars.map(&:id)).ids

    current_stars.each{ |star| star.update(unstarred: false) }
    self.stars << new_stars
    Star.where(id: old_star_ids).update_all unstarred: true
  end

  def client
    @client ||= Octokit::Client.new access_token: token, auto_paginate: true
  end
end
