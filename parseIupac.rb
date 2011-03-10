#!/usr/bin/env ruby
# encoding: utf-8
# parseIupac.rb
# 
# A recursive descent parser for processing simple alkanes named using 
#   IUPAC nomenclature into a format more suitable for downstream 
#   processing.  The format chosen outputting alkanes is an array of 
#   of dictionaries.  Each dict represents a single carbon in the described
#   molecule and contains a key 'bonds' referencing an array of integers,
#   indicating those carbons to which the referenced carbon shares a bond
#   with.


# Multiplicity prefixes for side chains
$subPrefixes = {1=>'',
                2=>'di',
                3=>'tri', 
                4=>'tetra', 
                5=>'penta',
                6=>'hexa', 
                7=>'hepta', 
                8=>'octa', 
                9=>'nona',
                10=>'deca', 
                11=>'undeca',
                12=>'duodeca',
                13=>'trideca',
                14=>'tetradeca',
                15=>'pentadeca',
                16=>'hexadeca',
                17=>'heptadeca',
                18=>'octadeca',
                19=>'nonadeca',
                20=>'icosa' }
                
# Chain length prefixes (IUPAC; length 1..10)
$chPrefixes  = {'meth'=>1,
                'eth'=>2,
                'prop'=>3,
                'but'=>4,
                'pent'=>5,
                'hex'=>6,
                'hept'=>7,
                'oct'=>8,
                'non' =>9,
                'dec'=>10,
                'undec'=>11,
                'duodec'=>12,
                'tridec'=>13,
                'tetradec'=>14,
                'pentadec'=>15,
                'hexadec'=>16,
                'heptadec'=>17,
                'octadec'=>18,
                'nonadec'=>19,
                'icos'=>20 }


class IupacError < StandardError
end

class IncorrectMultiplicityError < IupacError
end

class IncorrectNumberingError < IupacError
end

class IupacParsingError < IupacError
end


# A side chain on a larger carbon chain.
class SideChain
  def initialize(pos, length, sides=[])
    @pos    = pos         # Position of attachment on parent chain
    @length = length      # Base length
    @sides  = sides       # Array of sidechains on this side chain
  end

  def addSubChain(side)
    @sides.push(side)
  end

  def getSideChains()
    return @sides
  end
  
  def getLength()
    return @length
  end

  def setPosition(pos)
    @pos    = pos
  end

  def getPosition()
    return @pos
  end

  # This is the function that generates the array structure
  def getCarbons()
    carbons = []
    for ii in 0..(@length - 1)
      c = {'bonds'=>[]}
      
      if ii > 0
        c['bonds'].push(ii - 1)
      end
      
      if ii < (@length - 1)
        c['bonds'].push(ii + 1)
      end
      carbons.push(c)
    end
    
    for ii in 1..(@sides.length)
      newCarbons = (@sides[ii-1]).getCarbons
      newLen = carbons.length
      newCarbons.each do |nc|
        nc['bonds'].collect! do |b|
          b + newLen
        end
      end
      
      carbons[(@sides[ii-1]).getPosition-1]['bonds'].push(carbons.length)
      newCarbons[0]['bonds'].push((@sides[ii-1]).getPosition-1)
      carbons.concat(newCarbons)
    end
    
    return carbons
  end
end



# Main carbon chain molecular backbone.
class MainChain
  def initialize(length, sides=[])
    @length = length      # Main chain length
    @sides = sides        # Array of side chains
  end

  def addSideChain(side)
    @sides.push(side)
  end

  def getSideChains()
    return @sides
  end

  def getLength()
    return @length
  end
  
  # This is the function that generates the array structure
  def getCarbons()
    carbons = []
    for ii in 0..(@length - 1)
      c = {'bonds'=>[]}
      
      if ii > 0
        c['bonds'].push(ii - 1)
      end
      
      if ii < (@length - 1)
        c['bonds'].push(ii + 1)
      end
      carbons.push(c)
    end
    
    for ii in 1..(@sides.length)
      newCarbons = (@sides[ii-1]).getCarbons
      newLen = carbons.length
      newCarbons.each do |nc|
        nc['bonds'].collect! do |b|
          b + newLen
        end
      end
      
      carbons[(@sides[ii-1]).getPosition-1]['bonds'].push(carbons.length)
      newCarbons[0]['bonds'].push((@sides[ii-1]).getPosition-1)
      carbons.concat(newCarbons)
    end
    
    return carbons
  end
end


def parseSideChain(inString)
  wString = inString
  initialString = inString
  subChains = []
  if inString =~ /^(.*)([\d|,]+)-\((.*?)\)-?(.*)$/
    puts ("-- Processing complex substituent " + $2 + "-" + $3 + 
          " --") if $debug
    subSubChains = []
    wString = $1 + $4
    tempChain = $3
    pos = $2.split(',')
    pos.collect! do |n|
      n.to_i
    end

    res = parseSideChain(tempChain)
    
    while tempChain != res
      subSubChains.concat(res[0])
      puts ("-- Adding subchain " + res[0].to_s + " complex chain --") if $debug
      tempChain = res[1]
      puts ("-- Complex substituent text remaining: " + tempChain + 
            " --") if $debug
      res = parseSideChain(tempChain)
    end

    if tempChain =~ /^(.*)yl$/
      cLength = $chPrefixes[$1]
      raise IupacParsingError if not cLength
      puts ("-- Complex substituent core length=" + cLength.to_s + 
            " --") if $debug
    end

    for p in pos
      sc = SideChain.new(p, cLength, [])
      for ssc in subSubChains
        sc.addSubChain(ssc)
      end
      subChains.push(sc)
      puts ("-- Complex substituent added to C-" + p.to_s + " --") if $debug
    end
    
    puts ("-- Complex substituent processing complete, remaining text: " + wString + 
          " --") if $debug
    return [subChains.flatten, wString]
  else
    if inString =~ /^([\d|,]+)-(\w+?)yl-?(.*)$/
      wString = $3
      chain = $2
      pos = $1.split(',')
      pos.collect! do |n|
        n.to_i
      end

      numPrefix = $subPrefixes[pos.length]
      numPrefix1 = chain.slice(0, numPrefix.length)
      
      chain = chain[numPrefix.length, chain.length]
      cLength = $chPrefixes[chain]
  
      # The next 25 lines are all in order to determine if a parsing
      # error is due to a missing / incorrect numericPrefix 
      raise IncorrectMultiplicityError if numPrefix != numPrefix1

      if cLength == nil
        if pos.length == 1 
          pre_list = $subPrefixes.values_at(2,3,4,5,6,7,8,9).map do |n|
            '(?:' + n + ')'
          end
          reg = Regexp.new('^(?:' + pre_list.join('|') + '){1}(.*)$')
          if (rmatch = reg.match(chain))
            raise IncorrectMultiplicityError if rmatch.captures[0]
          else 
            raise IupacParsingError
          end
          raise IupacParsingError
        end
      end

      for p in pos
        sc = SideChain.new(p, cLength, [])
        subChains.push(sc)
      end
      return [subChains.flatten, wString]
    else
      return initialString
    end
  end
end


def parseBaseChain(inString)
  initialString = inString
  wString = inString
  if inString =~ /^(\w+)ane(.*)$/
    cLength = $chPrefixes[$1]
    wString = $2
    raise(IupacParsingError, "Incorrect or missing Base name") if cLength == nil
    return [cLength, wString]
  else
    raise(IupacParsingError, "Incorrect or missing Base name")
    return [0, initialString]
  end
end

def parseIupac(inString="ethane")
  sideChains = []
  wString = inString
  temp = parseSideChain(inString)
  while temp != wString
    sideChains.push(temp[0])
    wString = temp[1]
    temp = parseSideChain(wString)
  end

  sideChains.flatten!

  res = parseBaseChain(wString)
  wString = res[1]

  raise(IupacParsingError) if wString.length > 0

  mc = MainChain.new(length=res[0])
  sideChains.each {
    |sc|
    mc.addSideChain(sc)
  }
  return mc.getCarbons
end
