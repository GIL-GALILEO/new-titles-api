# frozen_string_literal: true

# represent a title
class Title < ApplicationRecord
  EXPIRE_AFTER_DAYS = 90

  belongs_to :institution

  def self.sync(titles)
    outcome = {
      new: 0, updated: 0, expired: expire_titles(titles.first.institution)
    }
    titles.each do |title|
      existing_title = Title.where(mms_id: title.mms_id)
      if existing_title.any?
        # TODO: Sometimes MMS IDs are duplicated in a single report- figure that out before this can be enabled
        # in the meantime ignore if MMS ID exists, but display count
        puts "Duplicate MMS ID found in report: #{title.mms_id}"
        # updated_title = existing_title.update(title.attributes(except: :id))
        outcome[:updated] += 1
      else
        saved_title = title.save
        outcome[:new] += 1 if saved_title
      end
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
