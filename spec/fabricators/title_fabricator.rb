# frozen_string_literal: true

Fabricator(:title) do
  institution Institution.limit(1).order(Arel.sql('RANDOM()')).first
  title Faker::Book.title
  author Faker::Book.author
  mms_id Faker::Number.number(16)
  material_type 'Book'
  receiving_date DateTime.now
end