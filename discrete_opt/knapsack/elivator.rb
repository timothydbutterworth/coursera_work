class Elivator
	def initialize(items)
		@state = :down
		@l = items.length-1
		@items = items
		initializeSolution
		@crrnt = 0
		@state = :down
		@done = false
		@firstTime = true
		@count = 0
	end
	def initializeSolution
		@solution = []
		@l.times {@solution<<0}
		@solution[0]=1
	end
	def nextMove
		if(@state==:down)
			moveDown()
		elsif(@state==:up)
			moveUp()
		elsif(@state==:bottom)
			@count = @count+1
			puts @solution.to_s+": "+@count.to_s
			@state = :up
		elsif(@state==:deadEnd)
			@state = :up
		elsif(@state==:top)
			puts "at the top"
			@done = true
		end
	end
	def moveUp
		if(@solution[@crrnt]==1)
			@state = :down
			@solution[@crrnt]=0
		else
			if(@crrnt>0)
				@crrnt = @crrnt - 1
			else
				@state=:top
			end
		end

	end
	def moveDown
		if(@crrnt<@l)
			if(!legit)
				@state=:deadEnd
				@firstTime = false
			else
				@crrnt = @crrnt + 1
				@solution[@crrnt]=1
			end
		else
			@state=:bottom
		end
	end
	def legit
		return !(@crrnt==1 && @firstTime)
	end
	def solve
		while(!@done)
			nextMove
		end
	end
end

items = []
4.times {items<<1}
puts items.to_s
puts "---"
el = Elivator.new(items)
el.solve