class CreateMartinis < ActiveRecord::Migration
  def change
    create_table :martinis do |t|
      t.string :name
      t.integer :volume
      t.timestamps
    end
  end
end
