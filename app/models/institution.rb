# frozen_string_literal: true

# model representing an Institution
class Institution < ApplicationRecord
  def initialize(d)
    super(d)
    self.api_key = if Rails.env.production?
                     SecureRandom.hex
                   else
                     "#{institution_code}_key"
                   end
  end
end
