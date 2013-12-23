Mode(Delim := ", ", Args*){
	local matched := [], maxCountNumbers := [], maxCount := 0, allArgs := Join(", ",Args*)
	for index, num in Args
	{
		if (inList(num,matched*)){
			continue
		}
		RegExReplace(allArgs,"(?<=^|, )" . num . "(,|$)","",count)
		if (count>=maxCount){
			if (count > maxCount){
				maxCount := count
				maxCountNumbers := [num]
			} else {
				maxCount := count
				maxCountNumbers.Insert(num)
			}
			matched.Insert(num)
		}
		count := 0
	}
	return Join(Delim,maxCountNumbers*)
}

Average(Args*){
  return Sum(Args*)/Args.MaxIndex()
}

Sum(Args*){
  total := 0
  for index, num in Args
    total += num
  return total
}

inList(item,List*){
	for index, element in List
	{
		if (item == element){
			return index
		}
	}
	return false
}

Median(Args*){
	if (Args.MaxIndex() == 1)
		return Args[1]
	Args := sortArray(Args)
	return !Mod(Args.MaxIndex(),2) ? (Args[firstNum := Floor(Args.MaxIndex()/2)]+Args[firstNum+1])/2 : Args[Floor(Args.MaxIndex()/2)]
}

Join(delim := "`n",params*){
	ret := ""
	for index, param in params
		ret .= (index == 1 ? "" : delim) . param
	return ret
}


sortArray(array,options := ""){
	array := Join("<-!-Delimeter-!->",array*)
	sort,array,%options%
	return StrSplit(array,"<-!-Delimeter-!->")
}