require 'dm-core'
require 'dm-migrations'
require 'csv'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/users.db")

class User
  include DataMapper::Resource
  property :id, Serial
  property :userName, String
  property :role, String
  property :password, String
  property :vote, Boolean
  property :firstPlace, String
  property :secondPlace, String
  property :thirdPlace, String
end

DataMapper.finalize()

def addUsersFromCSV(filepath)
  csvUsers = CSV.read(filepath)
  for users in csvUsers
    User.create(userName: users[0], role: users[2], password: users[1], vote: FALSE)
  end
end

def writeVotesToCsv(voters)
  CSV.open("voterData.csv", "wb") do |csv|
    for voter in voters
      csv << [voter.id, voter.userName, voter.firstPlace, voter.secondPlace, voter.thirdPlace]
    end
  end
end

