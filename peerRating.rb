require 'sintra'
require 'slim'
require 'csv'
require 'sqlite3'

get '/' do
  slim :main
end