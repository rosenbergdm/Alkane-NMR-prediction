def parseSideChain(inString)
  initialString = inString
  wString = inString
  if inString =~ /^(\d+(,\d+)*)-(.*)$/
    wString = $3
    pos = $1.split(',')
    pos.collect! do |n|
      n.to_i
    end
  else
    return initialString
  end
  
  if wString[0,1] == '('
    wString.reverse!.chop!.reverse!
    res = parseSideChain(wString)
    scs = res[1]
    wString = res[0]
  else
    scs = []
  end



  numPrefix = $subPrefixes[pos.length]
  numPrefix1 = wString.slice(0, numPrefix.length)

  raise IncorrectMultiplicityError if numPrefix != numPrefix1

  wString = wString.slice(numPrefix.length, wString.length)
  if wString =~ /^(\w+?)yl(.*)$/
    temp = $1
    cLength = $chPrefixes[temp]
    wString = $2
    if cLength == nil
      if pos.length == 1 
        pre_list = $subPrefixes.values_at(2,3,4,5,6,7,8,9).map do |n|
          '(?:' + n + ')'
        end
        reg = Regexp.new('^(?:' + pre_list.join('|') + '){1}(.*)$')
        if (rmatch = reg.match(temp))
          raise IncorrectMultiplicityError if rmatch.captures[0]
        else 
          raise IupacParsingError
        end

        raise IupacParsingError
      end
    end
  end


  if wString[0,1] == ')'
    wString.reverse!.chop!.reverse!
  end
  if wString[0,1] == '-'
    wString.reverse!.chop!.reverse!
  end

  sc = pos.collect do |p|
    s = SideChain.new(pos=p, length = cLength, sides=[])
    scs.each do |c|
      s.addSubChain(c)
      raise IncorrectNumberingError if cLength >= p
    end
    s
  end

  if wString[0,1] == '-'
    wString.reverse!.chop!.reverse!
  end

  return([wString, sc])
end
