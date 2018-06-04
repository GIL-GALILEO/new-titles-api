# frozen_string_literal: true

# represent a title
class Title < ApplicationRecord
  EXPIRY_DATE = 90

  belongs_to :institution

  def inst_name
    institution.name
  end

  def self.sync(titles)
    outcome = { new_count: 0, expired_titles: expire_titles }
    titles.each do |title|
      unless Title.where(mms_id: title.mms_id).exists?
        saved_title = title.save
        outcome[:new_count] += 1 if saved_title
      end
    end
  end

  def self.expire_titles
    old_titles = Title.where('created_at > ?', EXPIRY_DATE.days.ago)
    old_titles.destroy_all
    old_titles.length
  end
end
