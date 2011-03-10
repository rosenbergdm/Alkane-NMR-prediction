#!/usr/bin/env ruby
# encoding: utf-8
# printOutput.rb



$splitDescriptions = { 1=>'singlet',
                       2=>'doublet',
                       3=>'triplet',
                       4=>'quartet',
                       5=>'quintet',
                       6=>'sextet',
                       7=>'septet',
                       8=>'octet',
                       9=>'nonet',
                       10=>'decet',
                       11=>'undecet',
                       12=>'duodecet',
                       13=>'tridecet',
                       14=>'tetradecet',
                       15=>'pentadecet',
                       16=>'hexadecet',
                       17=>'heptadecet',
                       18=>'octadecet',
                       19=>'nonadecet',
                       20=>'eicocet' }




def getTotalSize(carbonList)
  return (2 * carbonList.length + 2)
end

def getSizeProportion(carbonList, magId)
  totSize = getTotalSize(carbonList)
  hydrogenCt = 0.0
  carbonList.each do |c|
    if c['magId'] == magId
      hydrogenCt = hydrogenCt + 4 - c['bonds'].length
    end
  end
  if totSize == 4
    return 1.0
  else
    return (hydrogenCt / totSize)
  end
end

def getSplitPattern(carbonList, id)
  splitPattern = {}
  magIds = []
  splitters = carbonList[id]['bonds'].collect do |b|
    if magIds.member?(carbonList[b]['magId'])
      splitPattern[carbonList[b]['magId']] += (4 - carbonList[b]['bonds'].length)
    else
      magIds.push(carbonList[b]['magId'])
      splitPattern[carbonList[b]['magId']] = (5 - carbonList[b]['bonds'].length)
    end
  end
  if splitPattern.values == []
    return [1]
  else
    return splitPattern.values
  end
end

def describePattern(splitPattern)
  desc = $splitDescriptions[splitPattern.pop] + "s"
  while splitPattern.length > 0
    desc = $splitDescriptions[splitPattern.pop] + "s of " + desc
  end
  desc2 = desc.sub("ets", "et")
  return ("A " + desc2)
end


def describeSize(sizeProp)
  if sizeProp > 0.0
    percentage = (sizeProp * 100).round.to_s
    desc = "(AUC approximately " + percentage + "% of total)"
    return desc
  else
    return ""
  end
end

def describePeak(splitPattern, sizeProp)
  desc1 = describePattern(splitPattern)
  desc2 = describeSize(sizeProp)
  if desc2 != ""
    desc = desc1 + " " + desc2
  else
    desc = ""
  end
  return desc
end


def describeAllPeaks(carbonList)
  splits = {}
  sizes = {}
  description = ""
  for ii in 0..(carbonList.length-1)
    id = ii
    magId = carbonList[ii]['magId']
    if sizes.has_key?(magId)
    else
      sizes[magId] = getSizeProportion(carbonList, magId)
      splits[magId] = getSplitPattern(carbonList, ii)
      newPeak = (describePeak(splits[magId], sizes[magId])) + "\n"
      if newPeak != "\n"
        description = description + newPeak
      else
        description = description
      end
    end
  end

  return description
end


