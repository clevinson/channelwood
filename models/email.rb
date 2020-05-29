require "sequel"

DB = Sequel.connect(ENV['DATABASE_URL'])

Sequel::Model.plugin :timestamps

class Email < Sequel::Model

end

Email.plugin :timestamps, :create=>:created_at