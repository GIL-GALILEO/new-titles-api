Fabricator(:title) do
  institution Institution.order('RANDOM()').first
  title Faker::Book.title
  author Faker::Book.author
  mms_id Faker::Number.number(16)
  material_type { %w(Book Journal).sample }
  receiving_date DateTime.now
end