require 'sinatra'
require 'slim'
require 'csv'
require 'sqlite3'
require './user'

# configure do
#   enable :sessions
#   set :username, 'frank'
#
# end

get ('/styles.css') { scss :styles }

get '/' do
  slim :main
end

get '/login' do

  slim :login
end

get '/error' do
  slim :error
end

post '/login' do
    @user = User.get(userName: params["username"])
    puts @user.userName
    if @user
      if @user.role == 'TA'
        redirect to('/userHomeTA')
      elsif @user.role == 'student'
        redirect to('/userHomeStudent')
      end
    else
      slim :login
    end
end

get '/createAccount' do
  @user = User.new
  slim :createAccount
end

get '/csvUpload' do
  userFile = params[:users]
  if userFile
    addUsersFromCSV(userFile)
  end
  @users = User.all
  # slim :csvUpload
  redirect to('/userHome')
end

get '/userHomeTA' do
  slim :userHomeTA
end

get '/userHomeStudent' do
  slim :userHomeStudent
end

post '/userHome?' do
  if params[:user]["userName"] !=~ /\A[a-z0-9_]{4,16}\z/
    redirect to '/error'
  else
    @user = User.create(params[:user])
    @role = @user.role
    if (@role == 'TA') ? (redirect to('/userHomeTA')) : (redirect to('/userHomeStudent'))
    end
  end
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