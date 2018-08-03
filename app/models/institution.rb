# frozen_string_literal: true

# model representing an Institution
class Institution < ApplicationRecord
  USG_SHORTCODE = 'usg'
  def initialize(d)
    super(d)
    self.api_key = if Rails.env.production?
                     SecureRandom.hex
                   else
                     "#{institution_code}_key"
                   end
  end
  def self.usg
    where(shortcode: USG_SHORTCODE).first
  end
  def usg?
    shortcode == USG_SHORTCODE
  end
end
