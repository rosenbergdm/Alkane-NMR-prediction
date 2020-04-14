#!/usr/bin/env ruby
# encoding: utf-8
# tc_generateNmr.rb

require_relative "parseIupac"
require_relative "scoreCarbon"
require_relative "printOutput"
require_relative "generateNmr"
require "test/unit"

class TestGenerateNmr < Test::Unit::TestCase

  # Test all simple alkanes
  def testSimpleGenerateNmr
    assert_equal("A singlet (AUC approximately 100% of total)\n", iupacToNmr('methane'))
    assert_equal("A quartet (AUC approximately 100% of total)\n", iupacToNmr('ethane'))
    assert_equal("A triplet (AUC approximately 75% of total)\nA septet (AUC approximately 25% of total)\n", iupacToNmr('propane'))
    assert_equal(iupacToNmr('pentane'), "A triplet (AUC approximately 50% of total)\nA triplet of quartets (AUC approximately 33% of total)\nA quintet (AUC approximately 17% of total)\n")
    assert_equal(iupacToNmr('hexane'), "A triplet (AUC approximately 43% of total)\nA quartet of triplets (AUC approximately 29% of total)\nA triplet of triplets (AUC approximately 29% of total)\n")
    assert_equal(iupacToNmr('heptane'), "A triplet (AUC approximately 38% of total)\nA quartet of triplets (AUC approximately 25% of total)\nA triplet of triplets (AUC approximately 25% of total)\nA quintet (AUC approximately 13% of total)\n")
    assert_equal(iupacToNmr('octane'), "A triplet (AUC approximately 33% of total)\nA triplet of quartets (AUC approximately 22% of total)\nA triplet of triplets (AUC approximately 22% of total)\nA triplet of triplets (AUC approximately 22% of total)\n")
    assert_equal(iupacToNmr('nonane'), "A triplet (AUC approximately 30% of total)\nA triplet of quartets (AUC approximately 20% of total)\nA triplet of triplets (AUC approximately 20% of total)\nA triplet of triplets (AUC approximately 20% of total)\nA quintet (AUC approximately 10% of total)\n")
    assert_equal(iupacToNmr('decane'), "A triplet (AUC approximately 27% of total)\nA triplet of quartets (AUC approximately 18% of total)\nA triplet of triplets (AUC approximately 18% of total)\nA triplet of triplets (AUC approximately 18% of total)\nA triplet of triplets (AUC approximately 18% of total)\n")
  end

  # Test cases of simple symmetry 
  def testSimpleSymmetry
    assert_equal(iupacToNmr('ethane'),
                 "A quartet (AUC approximately 100% of total)\n")
    assert_equal(iupacToNmr('2-methylpropane'), 
                 "A doublet (AUC approximately 90% of total)\n" +
                 "A decet (AUC approximately 10% of total)\n")
  end

  # Everything else
  def testComplexSymmetry
    assert_equal(iupacToNmr('2,2-dimethylpropane'),
                 "A singlet (AUC approximately 100% of total)\n") 
  end

  def testFails
    # Removed.  No exceptions should be 'thrown' at the 'user' level  Only 
    # error messages are permited.
  end

  # Test that usage message works.
  def testUsage
    f = open('temp_test_output', 'w')
    old_output = $stdout
    $stdout = f
    usage
    $stdout = old_output
    f.close

    f = open('temp_test_output')
    msg = f.gets
    f.close
  
    File.unlink('temp_test_output')

    assert_match(/USAGE:/, msg)
  end
end

