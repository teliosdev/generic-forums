class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.primary_key :id
      t.string      :name
    end

    create_table :ropes_tags do |t|
      t.primary_key :id
      t.integer    :rope_id
      t.integer    :tag_id
    end
  end
end
