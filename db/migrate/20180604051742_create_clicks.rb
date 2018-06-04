class CreateClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :clicks do |t|
      t.belongs_to :url, index: true
      t.string :country
      t.string :browser
      t.string :platform

      t.timestamps
    end
  end
end
