require 'sinatra'
require 'pry'
require 'sinatra/reloader' if development?
require 'logger'
require 'pstore'

enable :logging

logger = Logger.new("logs/dev.log")
logger.info("Sinatra started...")
#binding.pry

def log(msg)
	logger.info msg
	puts msg
end

$todoStore 	 = PStore.new("public/todo_s.pstore")

#binding.pry

get '/' do 
	@sortedItems = readAll
#	@sortedItems = sort(readAll)
	p @sortedItems
	p "Sorted Item length: #{@sortedItems.length}"
	erb :todo_list
end

post '/add_item' do
	addItem(params[:task], params[:delay])
	redirect '/'
end

post '/del_item/:id' do
	delItem(params[:id])
	redirect '/'
end

def addItem(task,delay)
	prio   	= task.downcase.include?("urgent")
	due		= Time.new + (3600 * 24 * delay.to_i)
	$todoStore.transaction do
		id = $todoStore.roots ? $todoStore.roots.length + 1 : 0
		$todoStore[id] = {:id=>id,:task=>task,:prio=>prio,:due=>due}
	end
#	td = Todo.new(task,delay,@numElements)
end

def delItem(id)
	puts "Hello, I'm your delete routine. ID = #{id}"
	$todoStore.transaction do  # begin read-only transaction, no changes allowed
		$todoStore.delete(id.to_i)
	end
end

def sort(allItems)
	sortedItems = allItems.sort do |o,p|   
		comp = o[:prio] <=> p[:prio]
		comp.zero? ? (p[:due] <=> o[:due]) : comp
	end
	return sortedItems
end

def readAll
	allItems = []
	$todoStore.transaction(true) do  # begin read-only transaction, no changes allowed
  		allItems = $todoStore.roots.map { |key| $todoStore[key] }
	end
  	return allItems
end

# def display(sortedItems)
# 	puts "Hello123"
# 	sortedItems.each {|item| puts item}
# end

# class Todo
# #	attr_reader :id, :task, :due, :prio
# #	@@id = sortedItems.length
# 	def initialize(task,delay,id)
# 		p "\n\n\nID:   #{id}\n\n\n"
# 		@id		= id
# 		@task   = task
# 		@prio   = task.downcase.include?("urgent")
# 		@due	= Time.new + (3600 * 24 * delay.to_i)
# 		$todoStore.transaction do
# 			$todoStore[@id] = self
# 		end
# 	end
# end



