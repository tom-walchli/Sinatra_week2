require 'sinatra'
require 'pry'
require 'sinatra/reloader' if development?
require 'logger'
require 'pstore'

enable :logging

logger = Logger.new("logs/dev.log")
logger.info("Sinatra started...")

def log(msg)
	logger.info msg
	puts msg
end

$todoStore 	 = PStore.new("public/todo_s.pstore")

get '/' do 
	@sortedItems = sort(readAll)
	p @sortedItems
	p "Sorted Item length: #{@sortedItems.length}"
	erb :todo_list
end

post '/add_item' do
	addItem(params[:task], params[:delay])
	redirect '/'
end

post '/del_item' do
	case params[:done].to_s
	when "true"
		delItem(params[:id])
	when "false"
		updateItem(params[:id])
	end
	redirect '/'
end

def addItem(task,delay)
	prio   	= task.downcase.include?("urgent") ? 0 : 1
	added	= Time.new
	due		= convertTime(added + (3600 * 24 * delay.to_f))
	added	= convertTime(added)
	$todoStore.transaction do
		id = $todoStore.roots ? $todoStore.roots.length + 1 : 0
		$todoStore[id] = {:id=>id,:task=>task,:prio=>prio,:due=>due,:added=>added,:done=>:false}
	end
end

def updateItem(id)
	$todoStore.transaction do 
		$todoStore[id.to_i][:done] = :true
	end
end

def convertTime(t)
	return t.strftime("%Y-%m-%d %H:%M:%S")
end

def delItem(id)
	puts "Hello, I'm your delete routine. ID = #{id}"
	$todoStore.transaction do  
		$todoStore.delete(id.to_i)
	end
end

def sort(allItems)
	return allItems.sort_by{|e| [e[:prio], e[:due]]}
end

def readAll
	allItems = []
	$todoStore.transaction(true) do  # begin read-only transaction, no changes allowed
  		allItems = $todoStore.roots.map { |key| $todoStore[key] }
	end
  	return allItems
end

