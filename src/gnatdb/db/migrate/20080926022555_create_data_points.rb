class CreateDataPoints < ActiveRecord::Migration
  def self.up
    create_table :data_points do |t|
      t.references :user
      t.string :label
      t.float :data

      t.timestamps
    end
  end

  def self.down
    drop_table :data_points
  end
end
