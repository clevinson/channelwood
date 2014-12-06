class Release < Ohm::Model
  include Ohm::DataTypes

  attribute :cat_no
  attribute :artist
  attribute :description
  attribute :title
  attribute :release_date
  attribute :published
  attribute :cover_art
  attribute :release_type
  attribute :images, Type::Array

  unique :cat_no
  index :cat_no

end