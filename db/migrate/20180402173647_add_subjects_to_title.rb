#type is a sort of flag,  will have either "Physical", or "Electronic" as values

class AddSubjectsToTitle < ActiveRecord::Migration[5.1]
  def change
    add_column :titles, :subjects, :string
    add_column :titles, :type, :string
  end
end
