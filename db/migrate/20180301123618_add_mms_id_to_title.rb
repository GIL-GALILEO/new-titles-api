# frozen_string_literal: true

# add a 'MMS ID' field to titles table
class AddMmsIdToTitle < ActiveRecord::Migration[5.1]
  def change
    add_column :titles, :mms_id, :string
  end
end
