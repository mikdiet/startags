class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
