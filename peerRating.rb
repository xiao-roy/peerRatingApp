require 'sinatra'
require 'slim'
require 'csv'
require 'sqlite3'
require 'bcrypt'
require 'sass'
require './user'

# configure do
#   enable :sessions
#   set :username, 'frank'
#   set :password, BCrypt::Password.new("$2a$10$GKGxT1l1G08A6FjXt/R/yu1uyUdpsQG.K9kUN7DG6uxGn9iUM.vrW")
#   password is frank
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

get '/loginTest' do
id = user.db.execute <<-SQL
  SELECT id FROM users WHERE userName = '#{params[:userName]}' AND password = '#{params[:password]}';
SQL
    # @user = User.get(params[:userName])
    # puts @user.userName
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

get '/vote' do
  slim :vote
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
  # redirect to('/userHome')
end

get '/userHomeTA' do
  slim :userHomeTA
end

get '/userHomeStudent' do
  slim :userHomeStudent
end

post '/userHome' do
  # if params[:user]["userName"] !=~ /\A[a-z0-9_]{4,16}\z/
  #   redirect to '/error'
  # else
    @user = User.create(params[:user])
    @role = @user.role
    if (@role == 'TA') ? (redirect to('/userHomeTA')) : (redirect to('/userHomeStudent'))
    end
  # end
end

get '/csvDownload' do
  @users = User.all
  content_type 'application/csv'
  attachment "voterData.csv"
  csv_string = CSV.generate do |csv|
    for voter in @users
      csv << [voter.id, voter.userName, voter.vote, voter.firstPlace, voter.secondPlace, voter.thirdPlace]
    end
  end
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
