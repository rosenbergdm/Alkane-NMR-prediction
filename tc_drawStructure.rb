#!/usr/bin/env ruby
# encoding: utf-8
# tc_generateNmr.rb

require_relative "parseIupac.rb"
require_relative "drawStructure.ruby"
require "test/unit"

class TestDrawStructure < Test::Unit::TestCase

  def testSimpleDrawings
    #NYI
  end

  def testComplexDrawings
    old_stdout = $stdout
    f = File.new('test_output_scratch', 'w')
    $stdout = f
    renderFromCarbons(parseIupac("3-methyl-4-(1,1-diethylpropyl)-heptane")).render
    f.close
    $stdout = old_stdout
    f = open('test_output_scratch')
    msg = f.readlines
    f.close
    File.unlink('test_output_scratch')
    f2 = open('complex_drawing.txt')
    correct_msg = f2.readlines
    f2.close

    assert_equal(msg, correct_msg)

  end
end
