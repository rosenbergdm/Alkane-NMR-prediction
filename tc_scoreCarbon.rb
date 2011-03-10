#!/usr/bin/env ruby
# encoding: utf-8
# tc_scoreCarbon.rb

require "scoreCarbon"
require "test/unit"
require "parseIupac"

class TestScoreCarbon < Test::Unit::TestCase
  
  def setup
    @structs = []
    @structs.push(parseIupac("propane"))
    @structs.push(parseIupac("2-methylpropane"))
  end


  def testSimpleScore
    assert_equal(30, scoreCarbon(0, @structs[0]))
    assert_equal(12, scoreCarbon(1, @structs[0]))
    assert_equal(30, scoreCarbon(2, @structs[0]))


  end

  def testScoreIdentical
    assert_equal(scoreCarbon(0, @structs[0]), scoreCarbon(2, @structs[0]))
    assert_equal(scoreCarbon(0, @structs[1]), scoreCarbon(2, @structs[1]))
    assert_equal(scoreCarbon(0, @structs[1]), scoreCarbon(3, @structs[1]))
  end

  def testScoreUnique
    assert_not_equal(scoreCarbon(0, @structs[0]), scoreCarbon(1, @structs[0]))
    assert_not_equal(scoreCarbon(0, @structs[1]), scoreCarbon(1, @structs[1]))
  end


  def teardown
    # No teardown needed
  end

end
