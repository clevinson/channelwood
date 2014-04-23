class Release < Ohm::Model
  attribute :cat_no
  attribute :artist
  attribute :description
  attribute :title
  attribute :release_date
  attribute :published
  reference :cover_art, :CoverArt
  collection :images, :Image

  unique :cat_no
  index :cat_no
end

class Image < Ohm::Model
  reference :release, :Release
  attribute :rank
  attribute :url
end

class CoverArt < Ohm::Model
  attribute :url
end