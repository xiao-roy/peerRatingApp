require 'sinatra'
require 'slim'
require 'csv'
require 'sqlite3'
require 'bcrypt'
require 'sass'
require './user'
include BCrypt

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
  @user = User.get(params[:userName])
  if @user
    if BCrypt::Password.new(@user.password) == params[:password]
      if @user.role == 'TA'
        redirect to('/userHomeTA')
      elsif @user.role == 'student'
        redirect to('/userHomeStudent')
      end
    else
      slim :error
    end
  else
    slim :error
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
    @user.update(:password => BCrypt::Password.create(@user.password))
    @user.reload
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
