class AddPositionToStars < ActiveRecord::Migration
  class Star < ActiveRecord::Base
  end

  def change
    add_column :stars, :position, :integer, default: 0, null: false
    reversible do |dir|
      dir.up do
        Star.destroy_all
      end
    end
  end
end
