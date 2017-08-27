class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.integer :guid
      t.text :title
      t.text :description
      t.datetime :pub_date
      t.text :link

      t.timestamps
    end
    add_index :jobs, :guid
  end
end
