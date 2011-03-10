#!/usr/bin/env ruby
# encoding: utf-8
# generateNmr.rb

require "parseIupac.rb"
require "scoreCarbon.rb"
require "printOutput.rb"
require "drawStructure"

def iupacToNmr(input_string)
  begin 
    carbons = parseIupac(input_string)

  rescue IncorrectMultiplicityError
    puts "Error: Multiplicity mismatch\n" + 
         "  Ensure that you use proper substituent multiplicity prefixes.\n" +
         "    3,4-dimethylhexane            <-- Good\n" + 
         "    3,4-methylhexane              <-- Bad, missing prefix\n" + 
         "    3-dimethylhexane              <-- Bad, wrong prefix\n"
    exit 17

  rescue IncorrectNumberingError
    puts "Error: IUPAC Nomenclature violation\n" + 
         "  Ensure that substituents are numbered correctly.\n" + 
         "    3-hexane                      <-- Good\n" + 
         "    4-hexane                      <-- Bad\n"
    exit 18

  rescue IupacParsingError
    puts "Error: Parse error\n" + 
         "  Given compound name(s) could not be parsed using the IUPAC rules\n"
         "  for systematic alkane naming."
    exit 19
  end

  scoreAllCarbons(carbons)
  result = describeAllPeaks(carbons)
  return result
end

def usage()
  message = <<-eos
  USAGE: ruby #{$PROGRAM_NAME} ALKANE [OPTIONS]
      Predict the 1H NMR spectra for a given alkane.
  
      Arguments:
        ALKANE                 A valid alkane name as defined under IUPAC 
                                 nomenclature. (Nomenclature rules available at
                                 <http://www.acdlabs.com/iupac/nomenclature/>)
                                 
      Options:
        -v, --verbose          Verbose output.
        -h, --help             Print this message.
        -d, --debug            Run in debugging mode
        -s, --structure        Generate Structure diagrams as well


      Examples:
        $ ruby #{$PROGRAM_NAME} methane
        $ ruby #{$PROGRAM_NAME} "3-ethylhexane"
        $ ruby #{$PROGRAM_NAME} "4-(1,1-dimethylpropyl)-decane"
        $ ruby #{$PROGRAM_NAME} "hexane" "3-methylhexane"


      Notes:
        1. Except for simple straight chain alkanes, the alkane name should be
           enclosed in quotes to ensure it is not subject to shell substitution.
        2. Common and 'trivial' names (such as isopropyl, tert-butyl-, etc) are
           not permitted.  Only systematic names are correctly parsed.
        3. Maximum backbone chain length is 20 carbons.
        4. This program only calculates peak splitting patterns and areas.  It does
           not attempt to predict chemical shift values.
        5. Several alkanes may be processed at once by listing them as shown in
           example 4 (above).
        6. Structure diagrams are for testing purposes only.
      
      Please report bugs to <bugs@davidrosenberg.me>.

  eos
  puts message
end



# Only run this if directly invoked (i.e. don't invoke on require/import
if $PROGRAM_NAME == __FILE__
  alk = []

  if ARGV.length > 0
    for ii in 0..ARGV.length-1
      arg = ARGV[ii]
      if arg =~ /^-{1,2}h/
        usage
        exit 0
      elsif arg =~ /^-{1,2}v/
        $VERBOSE=true           # TODO: NYI
      elsif arg =~ /^-{1,2}d/
        $debug=true
        $DEBUG=true
      elsif arg =~ /^-{1,2}s/
        $structure=true
      else
        # Collect and parse all arguments before beginning parsing and 
        # prediction of alkanes.
        alk.push(arg.to_s)
      end
    end


    if alk.length > 0
      alk.each do |a|
        # Calcualte before printing heading
        res = iupacToNmr(a) + "\n"
        puts a.upcase + "\n" + "-----------------------------"[0,a.length] 
        if $structure
          begin
            fig = renderFromCarbons(parseIupac(a))
            fig.render
          rescue
            puts "A figure could not be generated"
          end
        end
        puts res
      end
    else
      usage
      exit 1
    end
  else
    usage
    exit 1
  end

  exit 0
end
