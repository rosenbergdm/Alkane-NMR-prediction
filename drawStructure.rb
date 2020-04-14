#!/usr/bin/env ruby
# encoding: utf-8
# drawStructure.rb

require_relative "parseIupac"

def renderFromCarbons(carbonList)
  rendered = []
  for ii in 0..carbonList.length-1
    carbonList[ii]['id'] = ii
  end

  dr = Drawing.new
  dr.addBlock(0)
  rendered.push(0)

  carbonList.shift

  while carbonList.length > 0
    thisCarbon = carbonList.shift
    cids = thisCarbon['bonds'] & rendered
    if cids.length > 0
      cid = cids[0]
      rendered.push(thisCarbon['id'])
      dr.add(thisCarbon['id'], cid)
    else
      carbonList.push(thisCarbon)
    end
  end

  return dr
end



class Drawing
  def initialize
    @height = 0
    @width = 0
    @blocks = []
    @carbons = {}
  end

  def getBlocks
    return @blocks
  end

  def getBlockForId(carb)
    return @carbons[carb]
  end

  def getIdForBlock(blk)
    revDict = {}
    @carbons.each do |k, v|
      revDict[k] = v
      revDict[v] = k
    end
    return revDict[blk]
  end


  def getCarbonDict
    return @carbons
  end

  def add(id, targetId, symbol='C')
    raise StandardError if not id.is_a?Integer
    raise StandardError if not targetId.is_a?Integer
    bondTo=self.getBlockForId(targetId)
    self.addBlock(id, bondTo, symbol)
  end

  def render
    for row in @blocks
      rendering = ["", "", ""]
      for col in row
        temp = col.render
        rendering[0].concat(temp[0])
        rendering[1].concat(temp[1])
        rendering[2].concat(temp[2])
      end
      puts rendering
    end
  end

  def addExtension(before, direction='h')
    if direction == 'h'
      newCol = []
      for row in @blocks
        if row[before-1].getBonds.member?('r')
          newElement = Block.new(['l', 'r'], symbol='-')
        else
          newElement = Block.new()
        end
        row.insert(before, newElement)
      end
      @carbons.each_value do |v|
        if v[1] >= before
          v[1] += 1
        end
      end

    elsif direction == 'v'
      newRow = []
      row = @blocks[before-1]
      for blk in row
        if blk.getBonds.member?('b')
          newElement = Block.new(['t', 'b'], symbol='|')
        else
          newElement = Block.new()
        end
        newRow.push(newElement)
      end

      @blocks.insert(before, newRow)

      @carbons.each_value do |v|
        if v[0] >= before
          v[0] += 1
        end
      end
    end
  end

  def slideBond(id)
    blk = getBlockForId(id)
    bonds = @blocks[blk[0]][blk[1]].getBonds
    if bonds.length == 1
      b = bonds[0]
      if b == 'l' and @blocks[blk[0]][blk[1]-1].getSymbol == '-'
        @blocks[blk[0]][blk[1]-1] = @blocks[blk[0]][blk[1]]
        @blocks[blk[0]][blk[1]] = Block.new
        @carbons[id] = [blk[0], blk[1]-1]
      elsif b == 'r' and @blocks[blk[0]][blk[1]+1].getSymbol == '-'
        @blocks[blk[0]][blk[1]+1] = @blocks[blk[0]][blk[1]]
        @blocks[blk[0]][blk[1]] = Block.new
        @carbons[id] = [blk[0], blk[1]+1]
      elsif b == 't' and @blocks[blk[0]+1][blk[1]].getSymbol == '|'
        @blocks[blk[0]+1][blk[1]] = @blocks[blk[0]][blk[1]]
        @blocks[blk[0]][blk[1]] = Block.new
        @carbons[id] = [blk[0]+1, blk[1]]
      elsif b == 'b' and @blocks[blk[0]-1][blk[1]].getSymbol == '|'
        @blocks[blk[0]-1][blk[1]] = @blocks[blk[0]][blk[1]]
        @blocks[blk[0]][blk[1]] = Block.new
        @carbons[id] = [blk[0]-1, blk[1]]
      end
    end
  end


  def addBlock(id, bondTo=[0,0], symbol='C')
    puts "bondTo = [" + bondTo[0].to_s + "," + bondTo[1].to_s + "]" if $debug
    raise StandardError if not id.is_a?Integer
    if @height == 0
      @height += 3
      @width += 3
      @blocks.push([])
      @blocks[0].push(Block.new([], symbol))
      @carbons[id] = [0,0]
    else
      bl = @blocks[bondTo[0]][bondTo[1]]
      freeSides = bl.getOpenSides
      puts "freeSides = [" + freeSides.join(',') + "]" if $debug
      if freeSides.member?('r') and 
        ( (@blocks[bondTo[0]].last == bl) or
          (@blocks[bondTo[0]][bondTo[1] + 1].getSymbol == " "))
        if @blocks[bondTo[0]].last == bl
          @width += 3

          @blocks[bondTo[0]].last.addBond('r')
          @blocks[bondTo[0]].push( Block.new(['l'], symbol) )
          @carbons[id] = [bondTo[0], bondTo[1]+1]
          @width += 3
          for row in @blocks
            if row.length < @blocks[bondTo[0]].length
              row.push(Block.new)
            end
          end
        elsif @blocks[bondTo[0]][bondTo[1] + 1].getSymbol == " "
          @blocks[bondTo[0]][bondTo[1] + 1] = Block.new(['l'], symbol)
          @blocks[bondTo[0]][bondTo[1]].addBond('r')
          @carbons[id] = [bondTo[0], bondTo[1]+1]
        end
        
      elsif freeSides.member?('l') and 
        ( (bondTo[1] == 0) or
          (@blocks[bondTo[0]][bondTo[1]-1].getSymbol == " "))
        if bondTo[1] == 0
          @width += 3
          @carbons.each_value do |v|
            v[1] += 1
          end

          for row in @blocks
            row.unshift(Block.new)
          end
          @blocks[bondTo[0]][1].addBond('l')
          @blocks[bondTo[0]][0] = Block.new(['r'], symbol)
          @carbons[id] = [bondTo[0], 0]
        elsif @blocks[bondTo[0]][bondTo[1]-1].getSymbol == " "
          @blocks[bondTo[0]][bondTo[1]].addBond('l')
          @blocks[bondTo[0]][bondTo[1]-1] = Block.new(['r'], symbol)
          @carbons[id] = [bondTo[0], bondTo[1]-1]
        end

      elsif (freeSides.member?('t') and
        ((bondTo[0] == 0) or
         (@blocks[bondTo[0]-1][bondTo[1]].getSymbol == " ")))  
        
        if bondTo[0] == 0
          @blocks[bondTo[0]][bondTo[1]].addBond('t')
          @height += 3
          @carbons.each_value do |v|
            v[0] += 1
          end

          newRow = []
          while newRow.length < @blocks[0].length
            newRow.push(Block.new)
          end
          @blocks.unshift(newRow)
          @blocks[0][bondTo[1]] = Block.new(['b'], symbol)
          @carbons[id] = [0, bondTo[1]]
        else
          @blocks[bondTo[0]-1][bondTo[1]] = Block.new(['b'], symbol)
          @carbons[id] = [ bondTo[0]-1, bondTo[1] ]
          @blocks[bondTo[0]][bondTo[1]].addBond('t')
        end


      elsif (freeSides.member?('b') and
        ((bondTo[0] == @blocks.length-1) or
         (@blocks[bondTo[0]+1][bondTo[1]].getSymbol == " ")))

        if bondTo[0] == @blocks.length-1
          @height += 3
          newRow = []
          for ii in @blocks[0]
            newRow.push(Block.new)
          end

          newRow[bondTo[1]] = Block.new(['t'], symbol)
          @blocks[bondTo[0]][bondTo[1]].addBond('b')
          @blocks.push(newRow)
          @carbons[id] = [bondTo[0]+1, bondTo[1]]
        else 
          @blocks[bondTo[0]+1][bondTo[1]] = Block.new(['t'], symbol)
          @blocks[bondTo[0]][bondTo[1]].addBond('b')
          @carbons[id] = [bondTo[0]+1, bondTo[1]]
        end

      elsif (freeSides.member?('b'))
        targetId = self.getIdForBlock([bondTo[0], bondTo[1]])
        slideId = self.getIdForBlock([bondTo[0]+1, bondTo[1]])
        self.addExtension(bondTo[0], 'v')
        self.addExtension(bondTo[1])
        self.slideBond(slideId)
        self.add(id, targetId)
      end

    end
  end
end



class Block
  def initialize(bonds=[], symbol=' ')
    @symbol = symbol
    @bonds = bonds
  end


  def getSymbol
    return @symbol
  end

  def addBond(direction)
    @bonds.push(direction)
  end

  def getBonds 
    return ['t', 'l', 'b', 'r'] - self.getOpenSides
  end


  def getOpenSides
    allBonds = ['t','l','b','r']
    for b in @bonds
      if b == 't'
        allBonds.delete('t')
      elsif b == 'l'
        allBonds.delete('l')
      elsif b == 'b'
        allBonds.delete('b')
      elsif b == 'r'
        allBonds.delete('r')
      else
      end
    end
    return allBonds
  end
  
  def render
    topBond = " "
    leftBond = " "
    rightBond = " "
    bottomBond = " "

    for b in @bonds
      if b == 't'
        topBond = "|"
      elsif b == 'l'
        leftBond = '-'
      elsif b == 'r'
        rightBond = '-'
      elsif b == 'b'
        bottomBond = '|'
      else
        # Should not happen
      end
    end

    myStr = [" " + topBond + " ", leftBond + @symbol + rightBond, " " + bottomBond + " "]
    return myStr
  end

end
    
