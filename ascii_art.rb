require 'artii'
require 'sinatra'
require 'pry'
require 'sinatra/reloader' if development?
require 'logger'


enable :logging

logger = Logger.new("logs/log.log")
logger.info("Sinatra started...")
#binding.pry

def log(msg)
	logger.info msg
	puts msg
end

get '/' do 
	a = Artii::Base.new :font => 'slant'
	"<pre>" + a.asciify('Hello World!').split("\n").join("<br>") + "</pre>"
end

