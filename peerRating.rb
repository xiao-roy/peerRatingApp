require 'sinatra'
require 'slim'
require 'csv'
require 'sqlite3'
require './user'

get '/' do
  slim :main
end

get '/login' do
  slim :login
end

get '/createAccount' do
  slim :createAccount
end

get '/userHome?' do
  @username = params['username']
  @password = params['password']
  @role = params['role']
  (@role == 'TA') ? slim :userHomeTA : slim :userHomeStudent

  if params['users']
    addUsersFromCSV(params['users'])
  end
  slim :userHomeTA
end
# db = SQLite3::Database.new ":memory:"
#
# # Create a database
# rows = db.execute <<-SQL
#   create table users (
#     name varchar(30),
#     age int
#   );
# SQL
#
# csv = <<CSV
# name,age
# ben,12
# sally,39
# CSV
#
# CSV.parse(csv, headers: true) do |row|
#   db.execute "insert into users values ( ?, ? )", row.fields # equivalent to: [row['name'], row['age']]
# end
#
# db.execute( "select * from users" ) # => [["ben", 12], ["sally", 39]]