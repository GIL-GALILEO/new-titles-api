# frozen_string_literal: true

task get_daily_report: :environment do
  report = TitlesReport.new '/shared/Galileo Network/Reports/New Titles Electronic Daily'
  titles = report.titles
  outcome = Title.sync titles
  # Slack.info "New Titles List updated. `#{outcome[:new_count]}` titles added and `#{outcome[:expired_count]}` expired."
end

# TODO: mapping invalid
task get_physical_daily_report: :environment do
  report = TitlesReport.new '/shared/Galileo Network/Reports/New Physical Titles Daily'
  titles = report.titles
  outcome = Title.sync titles
  # Slack.info "New Titles List updated. `#{outcome[:new_count]}` titles added and `#{outcome[:expired_count]}` expired."
end

task get_physical_full_report: :environment do
  report = TitlesReport.new '/shared/Galileo Network/Reports/New Physical Titles'
  titles = report.titles
  outcome = Title.sync titles
  # Slack.info "New Titles List initialized for physical items. `#{outcome[:new_count]}` titles added."
end

task get_electronic_full_report: :environment do
  report = TitlesReport.new '/shared/Galileo Network/Reports/New Titles Electronic'
  titles = report.titles
  outcome = Title.sync titles
  # Slack.info "New Titles List initialized for electronic items. `#{outcome[:new_count]}` titles added."
end