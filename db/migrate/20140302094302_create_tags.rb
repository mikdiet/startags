class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :slug
      t.index :slug, unique: true

      t.timestamps
    end

    create_join_table :tags, :stars do |t|
      t.index :tag_id
      t.index :star_id
    end
  end
end
