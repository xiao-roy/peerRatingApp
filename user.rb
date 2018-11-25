require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/users.db")

class User
  include DataMapper::Resource
  property :id, Serial
  property :userName, String
  property :role, String
  property :password, String
  property :vote, String
end

DataMapper.finalize()