# A Parser, written in Ruby
# Purpose: Parsing Rapidminer to Matlab
# Written by: Christopher Sauer, 2014

# tested and working on:
# * ruby 2.1.1p76 (2014-02-24 revision 45161) [x86_64-darwin13.0]
# * ruby 2.0.0-p451 (x64) [win]
# should run if ruby >= 2.0.0

# see github for more details, issues, pull requests
# TODO: insert link here

#logo
$logo = <<EOF
____
|  _ \ __ _ _ __ ___  ___  _ __
| |_) / _` | '__/ __|/ _ \| '__|
|  __/ (_| | |  \__ \ (_) | |
|_|   \__,_|_|  |___/\___/|_|
                              v0.6
written by Christopher Sauer, 2014
EOF

# require all scripts
require_relative 'parsLinReg'
require_relative 'parsM5P'
require_relative 'parsM5Rules'
require_relative 'parsPolReg'

# Welcome
puts $logo
puts ""
puts "0: Executing Parsor"
$choiceMade = false

# Selection Menu
puts "0: Select your Type"
puts "(1) - LinReg"
puts "(2) - M5P"
puts "(3) - M5Rules"
puts "(4) - PolReg"

# Your selection
printf "0: "
selectionVal = gets.chomp.to_i
$choiceMade = true

if selectionVal == 1
    load "parsLinReg.rb"
elsif selectionVal == 2
    load "parsM5P.rb"
elsif selectionVal == 3
    load "parsM5Rules.rb"
elsif selectionVal == 4
    load "parsPolReg.rb"
elsif selectionVal == 666
    puts "The Number of the Beast!"
end
