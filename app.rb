require 'sinatra'
require 'tilt/erb'

set :environment, :development
set :database_file, "config/database.yml"
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'db/todos.sqlite3.db'
)

class Todo < ActiveRecord::Base
end

get '/' do
  @todos = Todo.all()
  #redirect "/create" if @todos.empty?
  erb :index
end

get '/create/?' do
  erb :create
end

post '/create/?' do
  @todo = Todo.new(params[:todo])
  if @todo.save
    redirect '/'
  else
    erb :create
  end
end

get '/update/:id/?' do
  @todo = Todo.find_by_id(params[:id])
  erb :update
end

post '/update/:id/?' do
  todo = Todo.find_by_id(params[:id])
  todo.body = params[:todo][:body]
  todo.category = params[:todo][:category]
  todo.save
  redirect '/'
end

post '/delete/:id/?' do
  Todo.destroy(params[:id])
  redirect '/'
end

post '/clear/?' do
  # Truncate SQLite table
  ActiveRecord::Base.connection.execute <<-SQL
DELETE FROM todos
SQL
  redirect '/'
end
