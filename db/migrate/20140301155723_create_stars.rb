class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.references :user
      t.references :repo
      t.boolean :unstarred, default: false, null: false

      t.timestamps
    end
  end
end
