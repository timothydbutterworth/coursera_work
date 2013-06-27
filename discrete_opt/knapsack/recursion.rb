def reverse(str)
	l = str.length
	if(str.length>1)
		return reverse(str[(l/2)...l]) + reverse(str[0...(l/2)])
	else
		return str
	end
end
def findSpace(str, depth)
	if(str!=nil && str.length!=0 && str[0]==' ')
		return depth
	elsif(str==nil || str.length==0)
		return -1
	else
		findSpace(str[1...str.length], depth+1)
	end
end
def sqr(n)
	return n*n
end
def sqrRt(n)
	crrntSolution = n/2
	while(!(sqr(crrntSolution+1)>n && sqr(crrntSolution)<n) && !(sqr(crrntSolution)==n))
		crrntSolution = ((n/crrntSolution)+crrntSolution)/2
		puts crrntSolution
	end
	return crrntSolution
end
n = 4
sq = sqrRt(n)
puts n
puts sq
puts sqr(sq)
puts sqr(sq+1)
#puts findSpace("there is", 0)
#puts reverse("cool-1234")