require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'blog.sqlite'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db 
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
	(
	  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	  created_date DATE NOT NULL,
	  content TEXT NOT NULL
	);'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
  erb :new
end

post '/new' do
	content = params[:content]

	if content.length <= 0
		@error = 'Введите текст поста!'
		return erb :new
	end

	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

	erb "Вы написали #{content}"
end