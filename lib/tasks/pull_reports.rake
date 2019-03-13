# frozen_string_literal: true

# Pull Report
task :get_new_titles, %i[institution type report_override] => :environment do |_, args|
  slack = Slack::Notifier.new Rails.application.secrets.slack_worker_webhook

  # ensure valid type
  raise StandardError unless %w[physical electronic].include? args[:type]

  # validate and set institutions
  institution = Institution.find_by_shortcode args[:institution]
  raise StandardError unless institution
  # slack.ping "Getting new `#{args[:type]}` titles for `#{institution.name}`" if Rails.env.production?

  # initiate and pull report
  report = TitlesReport.new(institution,
                            type: args[:type],
                            report_override: args[:report_override]
                           ).create

  # get titles from report
  titles = report.titles
  if titles.any?
    outcome = Title.sync titles
    slack.ping "Pulled `#{titles.size}` new #{args[:type]} titles for `#{institution.shortcode}`: `#{outcome[:new]}` titles added and `#{outcome[:expired]}` expired."
  else
    slack.ping "No new #{args[:type]} titles received for `#{institution.shortcode}`"
  end

end