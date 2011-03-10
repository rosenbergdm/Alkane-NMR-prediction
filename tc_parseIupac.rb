#!/usr/bin/env ruby
# encoding: utf-8
# tc_parseIupac.rb

require "parseIupac"
require "test/unit"

class TestParseIupac < Test::Unit::TestCase
  
  def testSimpleChains
    assert_equal([{'bonds'=>[]}], parseIupac('methane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0]}], 
                 parseIupac('ethane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1]}], 
                 parseIupac('propane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1,3]}, 
                  {'bonds'=>[2]}], 
                 parseIupac('butane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4]}, {'bonds'=>[3]}], 
                 parseIupac('pentane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4]}, {'bonds'=>[3,5]}, {'bonds'=>[4]}], 
                 parseIupac('hexane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4]}, {'bonds'=>[3,5]}, {'bonds'=>[4,6]}, 
                  {'bonds'=>[5]}], 
                 parseIupac('heptane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4]}, {'bonds'=>[3,5]}, {'bonds'=>[4,6]},
                  {'bonds'=>[5,7]}, {'bonds'=>[6]}], 
                 parseIupac('octane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4]}, {'bonds'=>[3,5]}, {'bonds'=>[4,6]},
                  {'bonds'=>[5,7]}, {'bonds'=>[6,8]}, {'bonds'=>[7]}], 
                 parseIupac('nonane'))

    assert_equal([{'bonds'=>[1]}, {'bonds'=>[0,2]}, {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4]}, {'bonds'=>[3,5]}, {'bonds'=>[4,6]},
                  {'bonds'=>[5,7]}, {'bonds'=>[6,8]}, {'bonds'=>[7,9]}, 
                  {'bonds'=>[8]}], 
                 parseIupac('decane'))
  end

  def testMultiplicities
    assert_equal([{'bonds'=>[1]},
                  {'bonds'=>[0,2]}, 
                  {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4,10]}, 
                  {'bonds'=>[3,5]}, 
                  {'bonds'=>[4,6]}, 
                  {'bonds'=>[5,7]}, 
                  {'bonds'=>[6,8]}, 
                  {'bonds'=>[7,9]}, 
                  {'bonds'=>[8]}, 
                    {'bonds'=>[3]}], 
                 parseIupac('4-methyldecane'))

    assert_equal([{'bonds'=>[1]}, 
                  {'bonds'=>[0,2]}, 
                  {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4,10,11]}, 
                  {'bonds'=>[3,5]}, 
                  {'bonds'=>[4,6]}, 
                  {'bonds'=>[5,7]}, 
                  {'bonds'=>[6,8]}, 
                  {'bonds'=>[7,9]}, 
                  {'bonds'=>[8]}, 
                    {'bonds'=>[3]}, 
                    {'bonds'=>[3]}], 
                 parseIupac('4,4-dimethyldecane'))

    assert_equal([{'bonds'=>[1]}, 
                 {'bonds'=>[0,2]}, 
                 {'bonds'=>[1,3,10]}, 
                 {'bonds'=>[2,4,11,12]}, 
                 {'bonds'=>[3,5]}, 
                 {'bonds'=>[4,6]}, 
                 {'bonds'=>[5,7]}, 
                 {'bonds'=>[6,8]}, 
                 {'bonds'=>[7,9]}, 
                 {'bonds'=>[8]}, 
                   {'bonds'=>[2]}, 
                   {'bonds'=>[3]}, 
                   {'bonds'=>[3]}], 
                parseIupac('3,4,4-trimethyldecane'))

    assert_equal([{'bonds'=>[1]}, 
                  {'bonds'=>[0,2]}, 
                  {'bonds'=>[1,3,10,11]}, 
                  {'bonds'=>[2,4,12,13]}, 
                  {'bonds'=>[3,5]}, 
                  {'bonds'=>[4,6]}, 
                  {'bonds'=>[5,7]}, 
                  {'bonds'=>[6,8]}, 
                  {'bonds'=>[7,9]}, 
                  {'bonds'=>[8]}, 
                    {'bonds'=>[2]}, 
                    {'bonds'=>[2]}, 
                    {'bonds'=>[3]}, 
                    {'bonds'=>[3]}], 
                 parseIupac('3,3,4,4-tetramethyldecane'))

    assert_equal([{"bonds"=>[1]}, 
                  {"bonds"=>[0, 2, 10]}, 
                  {"bonds"=>[1, 3, 11, 12]}, 
                  {"bonds"=>[2, 4, 13, 14]}, 
                  {"bonds"=>[3, 5]}, 
                  {"bonds"=>[4, 6]}, 
                  {"bonds"=>[5, 7]}, 
                  {"bonds"=>[6, 8]}, 
                  {"bonds"=>[7, 9]}, 
                  {"bonds"=>[8]}, 
                    {"bonds"=>[1]}, 
                    {"bonds"=>[2]}, 
                    {"bonds"=>[2]}, 
                    {"bonds"=>[3]}, 
                    {"bonds"=>[3]}], 
                 parseIupac('2,3,3,4,4-pentamethyldecane'))

    assert_equal([{"bonds"=>[1]},
                  {"bonds"=>[0, 2, 10, 11]}, 
                  {"bonds"=>[1, 3, 12, 13]},
                  {"bonds"=>[2, 4, 14, 15]}, 
                  {"bonds"=>[3, 5]}, 
                  {"bonds"=>[4, 6]},
                  {"bonds"=>[5, 7]}, 
                  {"bonds"=>[6, 8]}, 
                  {"bonds"=>[7, 9]}, 
                  {"bonds"=>[8]},
                    {"bonds"=>[1]}, 
                    {"bonds"=>[1]}, 
                    {"bonds"=>[2]}, 
                    {"bonds"=>[2]}, 
                    {"bonds"=>[3]}, 
                    {"bonds"=>[3]}    ],
                 parseIupac('2,2,3,3,4,4-hexamethyldecane'))

    assert_equal([{"bonds"=>[1]},
                  {"bonds"=>[0, 2, 10, 11]},
                  {"bonds"=>[1, 3, 12, 13]},
                  {"bonds"=>[2, 4, 14, 15]},
                  {"bonds"=>[3, 5, 16]},
                  {"bonds"=>[4, 6]},
                  {"bonds"=>[5, 7]},
                  {"bonds"=>[6, 8]},
                  {"bonds"=>[7, 9]},
                  {"bonds"=>[8]},
                    {"bonds"=>[1]},
                    {"bonds"=>[1]},
                    {"bonds"=>[2]},
                    {"bonds"=>[2]},
                    {"bonds"=>[3]},
                    {"bonds"=>[3]},
                    {"bonds"=>[4]}],
                 parseIupac('2,2,3,3,4,4,5-heptamethyldecane'))

    assert_equal([{"bonds"=>[1]},
                  {"bonds"=>[0, 2, 10, 11]},
                  {"bonds"=>[1, 3, 12, 13]},
                  {"bonds"=>[2, 4, 14, 15]},
                  {"bonds"=>[3, 5, 16, 17]},
                  {"bonds"=>[4, 6]},
                  {"bonds"=>[5, 7]},
                  {"bonds"=>[6, 8]},
                  {"bonds"=>[7, 9]},
                  {"bonds"=>[8]},
                    {"bonds"=>[1]},
                    {"bonds"=>[1]},
                    {"bonds"=>[2]},
                    {"bonds"=>[2]},
                    {"bonds"=>[3]},
                    {"bonds"=>[3]},
                    {"bonds"=>[4]},
                    {"bonds"=>[4]}],
                 parseIupac('2,2,3,3,4,4,5,5-octamethyldecane'))

    assert_equal([{"bonds"=>[1]},
                  {"bonds"=>[0, 2, 10, 11]},
                  {"bonds"=>[1, 3, 12, 13]},
                  {"bonds"=>[2, 4, 14, 15]},
                  {"bonds"=>[3, 5, 16, 17]},
                  {"bonds"=>[4, 6, 18]},
                  {"bonds"=>[5, 7]},
                  {"bonds"=>[6, 8]},
                  {"bonds"=>[7, 9]},
                  {"bonds"=>[8]},
                    {"bonds"=>[1]},
                    {"bonds"=>[1]},
                    {"bonds"=>[2]},
                    {"bonds"=>[2]},
                    {"bonds"=>[3]},
                    {"bonds"=>[3]},
                    {"bonds"=>[4]},
                    {"bonds"=>[4]},
                    {"bonds"=>[5]} ],
                 parseIupac('2,2,3,3,4,4,5,5,6-nonamethyldecane'))

    assert_equal([{"bonds"=>[1]},
                  {"bonds"=>[0, 2, 10, 11]},
                  {"bonds"=>[1, 3, 12, 13]},
                  {"bonds"=>[2, 4, 14, 15]},
                  {"bonds"=>[3, 5, 16, 17]},
                  {"bonds"=>[4, 6, 18, 19]},
                  {"bonds"=>[5, 7]},
                  {"bonds"=>[6, 8]},
                  {"bonds"=>[7, 9]},
                  {"bonds"=>[8]},
                    {"bonds"=>[1]},
                    {"bonds"=>[1]},
                    {"bonds"=>[2]},
                    {"bonds"=>[2]},
                    {"bonds"=>[3]},
                    {"bonds"=>[3]},
                    {"bonds"=>[4]},
                    {"bonds"=>[4]},
                    {"bonds"=>[5]},
                    {"bonds"=>[5]} ],
                 parseIupac('2,2,3,3,4,4,5,5,6,6-decamethyldecane'))
  end

  def testMissingMultiplicities
    assert_raise(IncorrectMultiplicityError) { parseIupac('4,4-methyldecane') }
    assert_raise(IncorrectMultiplicityError) { parseIupac('2,3-trimethyldecane') }
    assert_raise(IncorrectMultiplicityError) { parseIupac('2-dimethyldecane') }
  end


  def testSimpleSideChain
    assert_equal([{'bonds'=>[1]}, 
                  {'bonds'=>[0,2,10]}, 
                  {'bonds'=>[1,3]}, 
                  {'bonds'=>[2,4]}, 
                  {'bonds'=>[3,5]}, 
                  {'bonds'=>[4,6]}, 
                  {'bonds'=>[5,7]}, 
                  {'bonds'=>[6,8]}, 
                  {'bonds'=>[7,9]}, 
                  {'bonds'=>[8]}, 
                    {'bonds'=>[1]}], 
                 parseIupac('2-methyldecane'))

    assert_equal([{"bonds"=>[1]}, 
                  {"bonds"=>[0, 2]}, 
                  {"bonds"=>[1, 3, 10]}, 
                  {"bonds"=>[2, 4]}, 
                  {"bonds"=>[3, 5]}, 
                  {"bonds"=>[4, 6]}, 
                  {"bonds"=>[5, 7]}, 
                  {"bonds"=>[6, 8]}, 
                  {"bonds"=>[7, 9]}, 
                  {"bonds"=>[8]}, 
                    {"bonds"=>[11, 2]}, 
                    {"bonds"=>[10]}], 
                 parseIupac('3-ethyldecane'))

    assert_equal([{"bonds"=>[1]}, 
                  {"bonds"=>[0, 2]}, 
                  {"bonds"=>[1, 3]}, 
                  {"bonds"=>[2, 4, 10]}, 
                  {"bonds"=>[3, 5]}, 
                  {"bonds"=>[4, 6]}, 
                  {"bonds"=>[5, 7]}, 
                  {"bonds"=>[6, 8]}, 
                  {"bonds"=>[7, 9]}, 
                  {"bonds"=>[8]}, 
                    {"bonds"=>[11, 3]}, 
                    {"bonds"=>[10, 12]}, 
                    {"bonds"=>[11]}], 
                 parseIupac('4-propyldecane'))

    assert_equal([{"bonds"=>[1]}, 
                 {"bonds"=>[0, 2]}, 
                 {"bonds"=>[1, 3]}, 
                 {"bonds"=>[2, 4]}, 
                 {"bonds"=>[3, 5, 10]}, 
                 {"bonds"=>[4, 6]}, 
                 {"bonds"=>[5, 7]}, 
                 {"bonds"=>[6, 8]}, 
                 {"bonds"=>[7, 9]}, 
                 {"bonds"=>[8]}, 
                   {"bonds"=>[11, 4]}, 
                   {"bonds"=>[10, 12]}, 
                   {"bonds"=>[11, 13]}, 
                   {"bonds"=>[12]}], 
                 parseIupac('5-butyldecane'))
  end

  # As per Mike Gatney (TODO: DATE OF EMAIL HERE)
  #   This test is deprecated.  Instead all efforts are made to try to
  #   interpret a meaningful structure from the input string and not
  #   to attempt to validate input according to IUPAC standards.
  # def testNumberingError
  #   assert_raise(Exception) { parseIupac('2-ethylhexane') }
  #   assert_raise(Exception) { parseIupac('3-propylheptane') }
  # end

  def testComplexSideChain
    assert_equal([{"bonds"=>[1]}, 
                  {"bonds"=>[0, 2]}, 
                  {"bonds"=>[1, 3, 6]}, 
                  {"bonds"=>[2, 4]}, 
                  {"bonds"=>[3, 5]}, 
                  {"bonds"=>[4]}, 
                    {"bonds"=>[7, 8, 9, 2]}, 
                    {"bonds"=>[6]}, 
                      {"bonds"=>[6]}, 
                      {"bonds"=>[6]}], 
                 parseIupac('3-(1,1-dimethylethyl)hexane'))
    
    assert_equal([{"bonds"=>[1]}, 
                  {"bonds"=>[0, 2]}, 
                  {"bonds"=>[1, 3, 6]}, 
                  {"bonds"=>[2, 4]}, 
                  {"bonds"=>[3, 5]}, 
                  {"bonds"=>[4]}, 
                    {"bonds"=>[7, 8, 9, 2]}, 
                    {"bonds"=>[6]}, 
                      {"bonds"=>[6]}, 
                      {"bonds"=>[6]}], parseIupac('3-(1,1-dimethylethyl)-hexane'))
  end

  def testParseError
    assert_raise(IupacParsingError) { parseIupac('2-ethylen') }
    assert_raise(IupacParsingError) { parseIupac('2-ethylhexanee') }
  end
      
end


