#!/usr/bin/env ruby
# encoding utf-8
# tc_printOutput.rb

require "parseIupac"
require "scoreCarbon"
require "printOutput"
require "test/unit"

class TestPrintOutput < Test::Unit::TestCase
 
  def setup
    @alkane1 = scoreAllCarbons(parseIupac("propane"))
    @alkane2 = scoreAllCarbons(parseIupac("methane"))
    @alkane3 = scoreAllCarbons(parseIupac("2-methyl-3-ethylhexane")) 
  end

  def testGetSplit
    assert_equal(getSplitPattern(@alkane1, 0), [3])
    assert_equal(getSplitPattern(@alkane1, 2), [3])
    assert_equal(getSplitPattern(@alkane1, 1), [7])

    assert_equal(getSplitPattern(@alkane2, 0), [1])

    assert_equal(getSplitPattern(@alkane3, 2), [3,2,3])
    assert_equal(getSplitPattern(@alkane3, 3), [3,2])
    assert_equal(getSplitPattern(@alkane3, 4), [4,3])
  end

  def testGetSizeProp
    assert_equal(getSizeProportion(@alkane1, 30), 0.75)
    assert_equal(getSizeProportion(@alkane1, 12), 0.25)

    assert_equal(getSizeProportion(@alkane2, 0), 1.0)

    assert_equal(getSizeProportion(@alkane3, 16710), 0.15)
    assert_equal(getSizeProportion(@alkane3, 6774), 0.3)
    assert_equal(getSizeProportion(@alkane3, 1140), 0.1)
    assert_equal(getSizeProportion(@alkane3, 2436), 0.1)
    assert_equal(getSizeProportion(@alkane3, 1234567), 0.0)
  end

  def testDescribePeak
    # Covered by tc_generateNmr.rb
  end

  def testDescribePattern
    # covered by tc_generateNmr.rb
  end


end

