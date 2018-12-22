# frozen_string_literal: true

# represent a title
class Title < ApplicationRecord
  EXPIRE_AFTER_DAYS = 90

  belongs_to :institution

  def inst_name
    institution.name
  end

  def self.sync(titles)
    outcome = { new: 0, expired: expire_titles(titles.first.institution) }
    titles.each do |title|
      existing_title = Title.where(mms_id: title.mms_id)
      next if existing_title.any?

      saved_title = title.save
      outcome[:new] += 1 if saved_title
    end
    outcome
  end

  def self.expire_titles(institution)
    old_titles = Title.where(institution: institution)
                      .where('created_at < ?', EXPIRE_AFTER_DAYS.days.ago)
    old_titles.destroy_all
    old_titles.length
  end
end
