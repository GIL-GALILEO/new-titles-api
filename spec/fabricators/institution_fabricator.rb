# frozen_string_literal: true

Fabricator(:institution) do
  name 'Test Institution'
  institution_code '01GALI_TEST'
  api_key 'Test Key'
  shortcode  'test'
  url 'http://www.example.com'
end