# frozen_string_literal: true

task warm_reports: :environment do
  AlmaReportsApi.call report: '/shared/Galileo Network/Reports/New Titles Electronic Daily'
  AlmaReportsApi.call report: '/shared/Galileo Network/Reports/New Physical Titles Daily'
  # AlmaReportsApi.call report: '/shared/Galileo Network/Reports/New Physical Titles'
  # AlmaReportsApi.call report: '/shared/Galileo Network/Reports/New Titles Electronic'
  # Slack.info "New Titles List reports warmed up..."
end
