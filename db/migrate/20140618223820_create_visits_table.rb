class CreateVisitsTable < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.datetime "created_at"
      t.integer :submitter_id, null: false
      t.integer :shortened_url_id, null: false
    end
    add_index :visits, :created_at
  end
end
