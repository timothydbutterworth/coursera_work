def timRequire(file)
	require($home+'/'+file)
end
def getInitialSolution(l)
	result = []
	l.times {result << 0}
	return result
end
def increaseSolution(take, items, bundle, n)
	max = bundle[:sack].weight
	crrnt = bundle[:sltn]
	crrntWeight = 0
	l = items.length
	l.times do |i|
		crrntWeight = crrntWeight + (items[i].weight) * crrnt[i]
	end
	crrntWeight = crrntWeight + (items[n].weight) * take
	return (crrntWeight<=max)
end
def findSolution(n, take,items, bundle)
	crrnt = bundle[:sltn]
	if(n<items.length)
		if(increaseSolution(take, items, bundle, n))
			crrnt[n] = take

			findSolution(n+1, 1, items, bundle)
			findSolution(n+1, 0, items, bundle)
		end
	elsif(n==(items.length-1))
		crrntValue = getValue(crrnt)
		if(crrntValue>bundle[:best])
			bundle[:best] = crrntValue
			lst = []
			crrntValue.each { |v| lst << v }
			bundle[:bestsltn] = lst
		end
	end
end
timRequire('item.rb')
timRequire('sack.rb')
timRequire('bruteForce.rb')
file = File.new($home+'/'+$file, 'r')

first = true
sack = nil
items = []

file.each do |l|
	bits = l.split(' ')
	if(first)
		sack = KnapSack.new(bits[1])
		first = false
	else
		items << KsItem.new(bits[0], bits[1])
	end
end

crrntSltn = getInitialSolution(items.length)

searcher = BruteForce.new(items, sack.capacity)
searcher.solve

$resultV.append(searcher.best.to_s+' 0')
lst = searcher.bestSltn

lst.each do |i|
	$solution.add(i.to_s)
end

weight = 0
l = lst.length
l.times do |i|
	weight = weight + items[i].weight * lst[i]
end