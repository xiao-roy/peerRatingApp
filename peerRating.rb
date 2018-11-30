require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'csv'
require 'sqlite3'
require 'bcrypt'
require './user'

configure do
  enable :sessions
  set :username, 'bigBoss'
  set :password, BCrypt::Password.new("$2a$10$yLf.YaWLzDtqCUabFwQJDe2A3zMtcsL3q4P3EJJGGQYv0zw0d2DWK")
end

get '/' do
  slim :main
end

get '/login' do
  slim :login
end

post 'login' do
  if settings.username == params[:username] && settings.password == params[:password]
    session[:user] = true
    redirect to('/uploadSuccess')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end

get '/createAccount' do
  slim :createAccount
end

get '/userHome?' do
  @username = params['username']
  @password = params['password']
  @role = params['role']
  @title = "Voting Page"
  if params['users']
    addUsersFromCSV(params['users'])
  end
  slim :userHome
end

not_found do
  slim :not_found
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