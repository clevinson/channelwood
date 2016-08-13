require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL])

DB.create_table :releases do
  primary_key :id
  String :cat_no
  String :artist
  String :description
  String :title
  Date :release_date
  TrueClass :published
  String :cover_art
  String :hover_art
  String :release_type
  Timestamp :created_at
  Timestamp :updated_at
  String :images
end
