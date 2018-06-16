# frozen_string_literal: true

# migration to add fields to Institution model
class AddImageAndAuthFieldsToInst < ActiveRecord::Migration[5.2]
  def change
    change_table :institutions do |t|
      t.string :image
      t.string :api_key
    end
  end
end
