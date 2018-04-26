class AddAndRemoveTitleFields < ActiveRecord::Migration[5.1]
  def change
    change_table :titles do |t|
      t.remove :type
      t.date :portfolio_activation_date
      t.date :portfolio_creation_date
      t.string :classification_code
      t.string :availability
    end
  end
end
