require 'sinatra'
require 'slim'
require 'csv'
require 'sqlite3'
require './user'

configure do
  enable :sessions
  set :username, 'frank'

end

get ('/styles.css') { scss :styles }

get '/' do
  slim :main
end

get '/login' do
  slim :login
end

post '/login' do
    # order matters since settings.password is a BCrypt::Password
    if settings.username == params[:username] && settings.password == params[:password]
      session[:admin] = true
      redirect to('/user_home')
    else
      slim :login
    end
end

get '/createAccount' do
  @user = User.new
  slim :createAccount
end

post '/userHome?' do
  user = User.create(params[:user])
end

get '/csvUpload' do
  userFile = params[:users]
  if userFile
    addUsersFromCSV(userFile)
  end
  @users = User.all
  slim :csvUpload
  # redirect to('/userHome')
end

get '/userHome?' do
  @username = params['username']
  @password = params['password']
  @role = params['role']
  if (@role == 'TA') ? (slim :userHomeTA) : (slim :userHomeStudent)
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