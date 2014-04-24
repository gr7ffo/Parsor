# A Parser, written in Ruby
# Purpose: Parsing Rapidminer to Matlab
# Written by: Christopher Sauer, 2014

# tested and working on: 
# * ruby 2.1.1p76 (2014-02-24 revision 45161) [x86_64-darwin13.0]
# * ruby 2.0.0-p451 (x64) [win]
# should run if ruby >= 2.0.0

#logo
$logo = <<EOF
____                           
|  _ \ __ _ _ __ ___  ___  _ __ 
| |_) / _` | '__/ __|/ _ \| '__|
|  __/ (_| | |  \__ \ (_) | |   
|_|   \__,_|_|  |___/\___/|_|                                 
                               v0.1
created by Christopher Sauer, 2014        
EOF

# Welcome
puts $logo
puts ""
puts "1: Running preParser"
printf "1: Enter Filename: "

#==========================================================================

# preParser

# Insert your filname
fileName = gets.chomp
outName = "out1.txt"

# This is my Parser!
if fileName == "Fluch der Karibik" || fileName == "Pirates of the Caribbean"
  puts "Arrrrrrr I am a Pirate!"
  exit
end

# Opening File, catch possible Errors
begin
  inp = File.open(fileName, "r+")
  if inp
    puts "1: File opened successfully"
  end
rescue
  puts "1: File not found, aborting..."
  exit
end

# creating outputFile
out = File.open(outName, "w")

# Display if file is writeable
if File.writable?(fileName)
  puts "1: File is writeable, let's get it started!"
end

# Remove first lines?
printf "1: Would you like to remove the first lines or put them in a comment? (y,n) "
ans = gets.chomp

# Linecounter Inputfile
countIn = 1
# Linecounter Outputfile
countOut = 1

# Do for each line
inp.each do |line| 
  if countIn <= 3 && ans == "n" 
    # Comment first three lines
    out.puts("% " + line)
    countOut += 1
  end
  if countIn > 3 
    # Remove '|', ':'
    out.puts(line.tr(':|','').to_s)
    countOut += 1
  end
  countIn += 1
end

# Output
inp.close
out.close
puts "1: Outputfile " + outName + " and " + countOut.to_s + " lines written"

#==========================================================================

# parsEquation
# Files ready for Work
# out1.txt <= preParser
puts "2: Running parsEquation"

# Searchterm for Equations
printf "2: Enter your Parameter (e.g. UmformgradMAX): "
searchTerm = gets.chomp
searchTermFound = false
lineSearchTermFound = 0

# Equationterm
printf "2: Enter your desired Equationname (e.g. LM): "
eqName = gets.chomp

# Filenames
inName = "out1.txt"
eqsName = "equations.m"

# Files
inp = File.open(inName, "r+")
eqs = File.open(eqsName, "w")

# Linecounter Inputfile
countIn = 1
# Equationcounter
countEq = 1

# Stringesave
addString = ""

# Equationnumber 
eqNum = 1

# Equationswrite started yet?
startEquations = false

# Do for each line
inp.each do |line| 
  if line[searchTerm]
    searchTermFound = true
    lineSearchTermFound = countIn
    addString = eqName + eqNum.to_s + " = "
    # Number your Equations
    eqNum += 1
  elsif searchTermFound
    addString << line.to_s
    if line.length == 1
      searchTermFound = false
      # Output 
      eqs.printf(addString.delete "\n")
      # silence console out
      eqs.printf(";")
      eqs.printf("\n")
      countEq += 1
      addString = ""
    end
  end
  countIn += 1
end

# Short break write Files
puts "2: Writing to Files..."
inp.close
eqs.close
inp = File.open(inName, "r+")
# Output
puts "2: " + eqNum.to_s + " Equation(s) written to " + eqsName

# reset Linecounter
countIn = 1
# save values in array
sav = []
i = 0
# Find Start of Equations
inp.each do |line|
  if line[searchTerm]
    sav[i] = countIn
    i += 1
  end
  countIn += 1
end

# Equationfound Information
#puts "Equation found on line " + sav[0].to_s
 
# But first let me take a (sel)file
inp.close
outName = "out2.txt"
inp = File.open(inName, "r+")
out = File.open(outName, "w")

# reset Linecounter
countIn = 1
countOut = 1
# Write File
inp.each do |line|
  if countIn < (sav[0] - 1) && line.length > 1
    out.puts(line)
    countOut += 1
  end
  countIn += 1
end

# *sigh* Filehandling...
inp.close
out.close

# Output
puts "2: Outputfile " + outName + " and " + countOut.to_s + " lines written"

#==========================================================================

# ()remover
puts "3: Now running ()remover"

# Files ready for Work
# equations.m <= parsEquation
# out1.txt <= preParser
# out2.txt <= ()remover
inName = "out2.txt"
outName = "out3.txt"
  
# reset Linecounter
countIn = 1
countOut = 1

# Generate and open Files
inp = File.open(inName, "r+")
out = File.open(outName, "w")

inp.each do |line|
  if line["("]
    newline = line[0..(line.index('(') - 1)]
    out.puts(newline)
    countOut += 1
  else
    out.puts(line)
  end
  countIn +=1
end

# *sigh* Filehandling...
inp.close
out.close

# Output
puts "3: Outputfile " + outName + " and " + countOut.to_s + " lines written"

#==========================================================================

# ifElser
# Files ready for Work
# equations.m <= parsEquation
# out1.txt <= preParser
# out2.txt <= ()remover
# out3.txt <= ifElser
puts "4: Now starting the ifElser"

# inputfile
inName = "out3.txt"

# output
printf "4: Please enter the desired Name for my main output (e.g. out.m): "
outName = gets.chomp

# First Char of Variable
printf "4: Please enter the First Char of your Variable: "
varChar = gets.chomp

# reset Linecounter
countIn = 1
countOut = 1

# Generate and open Files
inp = File.open(inName, "r+")
out = File.open(outName, "w")

# Array for line lengths
lengths = []

# Do for each line
inp.each do |line|
  lengths[countIn] = line.length
  countIn += 1
end

# *sigh* Filehandling...
inp.close
out.close

# reset Linecounter
countIn = 1
countOut = 1

# Generate and open Files
inp = File.open(inName, "r+")
out = File.open(outName, "w")

# positionSafe
posVar = []

# do
inp.each do |line|
  posVar[countIn] = line.index(varChar)
  countIn += 1 
end

# *sigh* Filehandling...
inp.close
out.close

# reset Linecounter
countIn = 1
countOut = 1

# Filehandler
# Generate and open Files
inp = File.open(inName, "r+")
out = File.open(outName, "w")

#ifCounter
ifCounter = 1

# Dodo - ifElser (~works)
inp.each do |line|
  if countIn == 1
    out.puts("if " + line)
    ifCounter += 1
    countOut += 1
  elsif posVar[countIn] > posVar[(countIn - 1)]
    out.puts("if " + line)
    ifCounter += 1
    countOut += 1
  elsif posVar[countIn] == posVar[(countIn - 1)]
    out.puts("elseif " + line)
    countOut += 1
  elsif posVar[(countIn + 1)] < posVar[(countIn)]
    out.puts("end")
    countOut += 1
    ifCounter -= 1
  end
  countIn += 1
end

# ending all ifs (hope)
for i in 2..ifCounter
  out.puts("end")
  countOut += 1
end

#== older way ==#
#runvariable i
#ifCounter = 1
## nearly~Working
# do for each
#inp.each do |line|
# Insert if when line has greater or equal length
#  if lengths[countIn].to_i > lengths[(countIn - 1)].to_i 
#    ifCounter += 1
#    out.puts("if " + line)
#    countOut += 1
#  else
#    ifCounter += 1
#    out.puts("elsif " + line)
#    countOut += 1
#  end
#  countIn += 1
#end
#for i in 2..ifCounter
#  out.puts("end")
#  countOut += 1
#end
#== end ==#

# *sigh* Filehandling...
inp.close
out.close

# Output
puts "4: Outputfile " + outName + " and " + countOut.to_s + " lines written"

# for functionfile generation
calcFile = outName

#==========================================================================

# genMatFun
# Files ready for Work
# equations.m <= parsEquation, genMatFun
# out1.txt <= preParser
# out2.txt <= ()remover
# out3.txt <= ifElser
# out4.m <= generated from ifElser
# varChar-variable for scanning for Variables
puts "5: Now generating matlab functions with genMatFun"

# Files
inName = "equations.m"

# Generate and open Files
inp = File.open(inName, "r+")

# reset Linecounter
countIn = 1
countOut = 1

# Variable Array
vars = []
nVars = 0;

# For the user
puts "5: Starting variable search"

# Dododo
inp.each do |line|
  lineFromX = line
  while lineFromX[varChar]
    # Where is the Variable?
    pos = lineFromX.index(varChar)
    # the first cut is the deepest...
    lineFromX = lineFromX[pos..-1]
    # Search for next blank
    posBlank = lineFromX.index(" ")
    # Save Variables
    vars[nVars] = lineFromX[0..posBlank]
    nVars += 1
    # the second cut
    lineFromX = lineFromX[posBlank..-1]
  end
end

# take only unique variables 
vars = vars.uniq
if vars.length == 0
  puts "5: no Variables found!"
else
  puts "5: " + vars.length.to_s + " Variable(s) found!" 
end

# set functionName
printf "5: Please enter your desired functionName for Matlab (e.g. myfun): "

# functionName
functionName = gets.chomp
outName = functionName + ".m" 
out = File.open(outName, "w")

# print to file
# first line
out.printf "function f = " + functionName + "("
for i in 0..(vars.length - 1) 
  out.printf vars[i]
  if i < vars.length - 1
    out.printf ","  
  end
end
out.printf ")"
out.printf "\n"
countOut += 1
# varDef
for i in 0..(vars.length - 1)
  out.puts vars[i] + " = " + vars[i] + ";"
  countOut += 1
end
# Call equations and deliver output
out.puts(inName[0..(inName.index(".")-1)] + ";") 
countOut += 1
out.puts(calcFile[0..(calcFile.index(".") - 1)])
countOut += 1
# endfunction
out.puts("end")
countOut += 1

# *sigh* Filehandling...
inp.close
out.close

# Output
puts "5: Functionfile " + outName + " and " + countOut.to_s + " lines written"

# Last Call
puts "0: Now use your generated Functionfile " + outName + " for simple Matlab Execution"

# Removing unused files
File.delete("out1.txt")
File.delete("out2.txt")
File.delete("out3.txt")
