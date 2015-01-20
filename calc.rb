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
	erb :calc
end

post '/add' do
	binding.pry
	n1 = params[:nbr1].to_f
	n2 = params[:nbr2].to_f
	"The result is: #{n1+n2}"
end

post '/subtract' do
	n1 = params[:nbr1].to_f
	n2 = params[:nbr2].to_f
	"The result is: #{n1-n2}"
end

post '/multiply' do 
	n1 = params[:nbr1].to_f
	n2 = params[:nbr2].to_f
	"The result is: #{n1*n2}"
end

post '/divide' do 
	n1 = params[:nbr1].to_f
	n2 = params[:nbr2].to_f
	"The result is: #{n1/n2}"
end

get '/count' do
	i = 0
	s = ""
	while i < 200
		s += "#{i+=1}<br>"
	end
	"#{s}"
end

