require "sequel"

DB = Sequel.connect(ENV['POSTGRES_CONN'])

Sequel::Model.plugin :timestamps

class Release < Sequel::Model
  def images
    if values[:images].nil?
      []
    else
      values[:images].split(",")
    end
  end
  def images= val
    values[:images] = val.join(",")
  end
end

Release.plugin :timestamps, :create=>:created_at, :update=>:updated_at
