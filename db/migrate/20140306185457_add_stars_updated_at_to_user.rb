class AddStarsUpdatedAtToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def change
    add_column :users, :stars_updated_at, :datetime
    User.reset_column_information
    User.update_all stars_updated_at: Time.current
  end
end
