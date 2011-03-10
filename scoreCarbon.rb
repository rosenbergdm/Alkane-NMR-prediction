#!/usr/bin/env ruby
# encoding: utf-8
# scoreCarbon.rb
# 
# Algorithm for determining magnetically distinct carbons within a particular
#   alkane.  The functions scoreCarbon() returns a value for a given carbon 
#   (as dictated by the id= argument) which encodes its magnetic environment.
#   Two carbons will be given identical scores if and only if they are
#   magnetically identical.


# Integer factorial
def factorial(n)
  if n == 0
    return 1
  else
    return (n * factorial(n-1))
  end
end
  
# Calculate a 'score' for each carbon.  Two carbons with identical scores
# are symmetrical across some axis within the molecule.
def scoreCarbon(id=0, carbons=[{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1]}])
  visited = []
  queue = [[id, 1]]
  scores = []
  
  while queue.length > 0
    temp = queue.pop
    if visited.member?(temp[0])
      scores.push(factorial(temp[1]))
    else
      visited.push(temp[0])
      bonds = carbons[temp[0]]['bonds']
      bonds.each do |b|
        queue.push([b, temp[1]+1])
      end
    end
  end
  
  score = 0
  scores.each do |s|
    score = score + s
  end
  
  return score
end

def scoreAllCarbons(carbonList)
  for ii in 0..(carbonList.length - 1)
    carbonList[ii]['magId'] = scoreCarbon(ii, carbonList)
  end
  return carbonList
end

