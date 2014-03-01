class User < ActiveRecord::Base

  def self.from_omniauth(oauth)
    return unless oauth['provider'] == 'github'
    find_or_initialize_by(uid: oauth['uid']).tap do |user|
      user.name =  oauth['info']['name']
      user.email = oauth['info']['email']
      user.token = oauth['credentials']['token']
      user.save
    end
  end
end
