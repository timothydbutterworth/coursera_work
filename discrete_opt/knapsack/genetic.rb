require_relative('item.rb')
require_relative('sack.rb')
def loadData(data_file)
	map = {}
	file = File.new(data_file,'r')
	sack = nil
	items = []

	first = true
	file.each do |l|
		bits = l.split
		if(first)
			sack = KnapSack.new(bits[1])
			first = false
		else
			items<<KsItem.new(bits[0], bits[1])
		end
	end
	file.close
	map[:sack] = sack
	map[:items] = items
	return map
end
def makeSolutions(n, l)
	lst = []
	n.times do
		crrnt = []
		l.times {crrnt<<rand(2)}
		lst << crrnt
	end
	return lst
end
def dotProduct(ns, items, proc)
	result = 0
	l = ns.length
	l.times do |i|
		result += proc.call(ns[i],items[i])
	end
	return result
end
def getMaxRatio(items)
	result = 0
	items.each do |i|
		if(i.valueratio>result)
			result = i.valueratio
		end
	end
	return result
end
def specialSort(pop, fitness)
	pop.sort! { |a, b| fitness.call(a) <=> fitness.call(b)}
	pop.reverse!
end
def reverse(arry, n)
	lst = []
	l = arry.length
	l.times do |i|
		if(i!=n)
			lst<<arry[i]
		else
			lst<<((arry[i]==1)? 0 : 1)
		end
	end
	return lst
end
def mutate(arry, fitness)
	l = arry.length
	pnt = rand(l)
	c = pnt
	result = arry
	if(rand(2)==1)
		# puts "random"
		result = reverse(result, rand(l))
	end
	l.times do |i|
		c = (pnt+i)%l 
		if(fitness.call(result)<fitness.call(reverse(result, c)))
			result = reverse(result,c)
		end
	end
	return result
end
def getBest(pop, fitness)
	result = pop[0]
	pop.each do |p|
		if(fitness.call(p)>fitness.call(result))
			result = p
		end
	end
	return result
end
vcombiner = Proc.new do |n,item|
	n*item.value
end
wcombiner = Proc.new do |n,item|
	n*item.weight
end

map = nil
if($home!=nil)
	map = loadData($home+'/'+$file)
else
	map = loadData('./data/ks_400_0')
end
sack = map[:sack]
items = map[:items]

maxRatio = getMaxRatio(items)

fitness = Proc.new do |p|
	v = dotProduct(p,items, vcombiner)
	w = dotProduct(p,items, wcombiner)
	result = 0
	if(w>sack.capacity)
		result = (sack.capacity-w)
	else
		result = v
	end
	result
end


#puts maxRatio

#puts items.length
population = makeSolutions(25, items.length)

#puts fitness.call(population[0],items)

i = 0
best = 0

specialSort(population, fitness)


# population.each do |p|
# 	puts p.to_s
# 	puts fitness.call(p)
# end

best = population[0]
1000.times do |i|
	puts "generation #{i.to_s}"
	nextPopulation = []
	population.each do |p|
		nextPopulation << mutate(p, fitness)
	end
	population = nextPopulation
	genBest = getBest(population, fitness)
	if(fitness.call(genBest)>fitness.call(best))
		best = genBest
	end
	puts "gb:"+fitness.call(genBest).to_s+" b:"+fitness.call(best).to_s
end

if($resultV!=nil)
	$resultV.append(fitness.call(best).to_s+' 0')
	best.each do |i|
		$solution.add(i.to_s)
	end
else
	puts fitness.call(best)
	puts best.to_s
	puts best.length
end