class BruteForce
	attr_accessor :best, :bestSltn
	def initialize(items, capacity)
		@items = items
		@capacity = capacity
		#@root = SolveNode.new
		# @crrntNode = @root
		setBaseSolution()
	end
	def setBaseSolution()
		@bestSltn = []
		l = @items.length
		l.times { @bestSltn << 0 }
		@best = 0
	end
	def solve()
		crrntNode = SolveNode.new(@items[0].value, @items[0].weight)
		crrntNode.depth = 0
		crrntNode.solutionSoFar = []
		crrntNode.totalw = 0
		crrntNode.totalv = 0
		bruteSolve(crrntNode)
	end
	def bruteSolve(crrntNode)
		depth = crrntNode.depth
		if(depth<@items.length)
			bound = getBound(@capacity - crrntNode.totalw, crrntNode.depth, crrntNode.totalv)
			#puts bound
			if(bound>@best)
				item = @items[depth]
				w = item.weight
				v = item.value
				crrntNode.buildUse(v, w)
				if(crrntNode.usenode.totalw<@capacity)
					bruteSolve(crrntNode.usenode)
				end
				crrntNode.buildUnuse(v, w)
				bruteSolve(crrntNode.unusenode)
			end
		else
			if(crrntNode.totalv>@best)
				@best = crrntNode.totalv
				@bestSltn = crrntNode.copySolutionSoFar
			end
		end
	end
	def getBound(slack, depth, crrntValue)
		lst = []
		(@items.length-depth).times do |i|
			lst << @items[depth+i]
		end
		lst = begin 
			lst.sort { |a,b| a.valueratio <=> b.valueratio}
		rescue Exception => e
			puts lst.to_s
			puts e.message
		end
		# lst.sort! { |a,b| a.valueratio <=> b.valueratio}
		lst.reverse!
		#puts lst.to_s
		result = crrntValue
		weight = 0
		i = 0
		crrnt = nil
		while(weight<slack && i<lst.length)
			crrnt = lst[i]
			if(weight+crrnt.weight<slack)
				weight += crrnt.weight
				result += crrnt.value
			else
				result += crrnt.valueratio*(slack-weight)
				weight = slack
			end
			i+=1
		end
		return result
	end
end

class SolveNode
	attr_accessor :usenode, :unusenode, :value, :weight, :solutionSoFar, :depth, :totalv, :totalw, :bound
	def initialize(value, weight)
		@value = value
		@weight = weight
	end
	def buildUse(value, weight)
		@usenode = SolveNode.new(value, weight)
		populate(1, @usenode)
	end
	def buildUnuse(value, weight)
		@unusenode = SolveNode.new(value, weight)
		populate(0, @unusenode)
	end
	def populate(n, node)
		lst = copySolutionSoFar
		lst << n
		node.solutionSoFar = lst
		node.depth = @depth + 1
		node.totalv = @totalv + node.value*n
		node.totalw = @totalw + node.weight*n	
	end
	def copySolutionSoFar()
		lst = []
		@solutionSoFar.each { |i| lst<<i}
		return lst
	end
end
