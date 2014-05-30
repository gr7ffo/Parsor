# A Parser, written in Ruby
# Purpose: Parsing Rapidminer to Matlab
# Written by: Christopher Sauer, 2014

# tested and working on:
# * ruby 2.1.1p76 (2014-02-24 revision 45161) [x86_64-darwin13.0]
# * ruby 2.0.0-p451 (x64) [win]
# should run if ruby >= 2.0.0

# see github for more details, issues, pull requests
# https://github.com/Balagrio/Parsor - if not found => private Repository
# better mail me: christopher.sauer@fau.de

#logo
$logo = <<EOF
____
|  _ \ __ _ _ __ ___  ___  _ __
| |_) / _` | '__/ __|/ _ \| '__|
|  __/ (_| | |  \__ \ (_) | |
|_|   \__,_|_|  |___/\___/|_|
                              v0.7
written by Christopher Sauer, 2014
EOF

# Welcome
puts $logo
puts ""
puts "0: Executing Parsor"
$choiceMade = false

# Selection Menu
puts "0: Which type do you want me to parse?"
puts "(1) - LinReg"
puts "(2) - M5P"
puts "(3) - M5Rules"
puts "(4) - PolReg"

# Your selection
printf "0: "
selectionVal = gets.chomp.to_i
$choiceMade = true

# Programm running for Linear Regression
#==========================================================================
#==========================================================================
if selectionVal == 1
    # pars LinReg by Christopher Sauer, 2014

    # run not until choice is made
    if $choiceMade
        startTime = Time.now
        # running
        puts "0: Running LinReg-Parser"


        # preParser
        #==========================================================================

        # Insert your filename
        printf "1: Enter Filename: "
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

        # Creating first outputfile
        out = File.open(outName, "w")

        # Display if file is writeable
        if File.writable?(fileName)
            puts "1: File is writeable, let's get it started!"
        end

        # First Char of Variable
        printf "1: Please enter the First Char of your Variables (e.g. X for X_T0_A0): "
        varChar = gets.chomp

        # Linecounter Inputfile
        countIn = 1
        # Linecounter Outputfile
        countOut = 1

        # Do for each line
        inp.each do |line|
            # remove first line
            if countIn > 2
                out.puts(line)
                countOut +=1
            elsif countIn == 2
                out.puts(line[20..-1])
                countOut += 1
            end
            countIn += 1
        end

        # Close files
        inp.close
        out.close

        # Generate output
        puts "1: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # parsEquation
        #==========================================================================

        # Files ready for Work
        # out1.txt <= preParser
        puts "2: Parsing linReg Equation"

        # vars for this operation
        eqName = "LR"
        equationString = ""

        # Filenames input
        inName = "out1.txt"
        eqsName = "LRequation.m"

        # Files
        inp = File.open(inName, "r+")
        eqs = File.open(eqsName, "w")

        # Linecounter Inputfile
        countIn = 1

        # write first line
        equationString = eqName + " = "
        eqs.printf(equationString)

        # Do for each line
        inp.each do |line|
            equationString << (line[0..-3] + " ")
            countIn += 1
        end

        # silence output
        equationString << ";"

        # write in output
        eqs.puts(equationString)

        # write to files
        puts "2: Writing to Files..."
        inp.close
        eqs.close

        # Generate output
        puts "2: Equation written to " + eqsName


        # genMatFun
        #==========================================================================

        # Files ready for Work
        # LRequation.m <= parsEquation, genMatFun
        # out1.txt <= preParser

        # varChar-variable for scanning for Variables
        puts "3: Generating matlab function"

        # Files
        inName = "LRequation.m"

        # Generate and open Files
        inp = File.open(inName, "r+")

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Variable Array for your variables
        vars = []
        nVars = 0;

        # Infos for the user
        puts "3: Starting variable search"

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

        # Remove duplicate variables
        vars = vars.uniq
        if vars.length == 0
            puts "3: no Variables found!"
        else
            puts "3: " + vars.length.to_s + " Variable(s) found!"
        end

        # Set name of your function for matlab
        printf "3: Please enter your desired functionName for Matlab (e.g. myfun): "

        # Generate file for function
        functionName = gets.chomp
        outName = functionName + ".m"

        # Opening
        out = File.open(outName, "w")

        # print to file
        # first line
        out.printf "function [" + eqName +"] = " + functionName + "("
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
        # insert equation
        out.puts(equationString)

        # endfunction
        out.puts("end")
        countOut += 1

        # *sigh* Filehandling...
        inp.close
        out.close

        # Generating output
        puts "3: Functionfile " + outName + " and " + countOut.to_s + " lines written"

        # Information for the user
        puts "3: Now use your generated Functionfile " + outName + " for simple Matlab Execution with variable handling for Matlab"

        # Ask if unused files should be deleted
        print "3: Should unused files be deleted? (y,n) "
        answer = gets.chomp

        if answer == "y"
            # Removing unused files
            File.delete("out1.txt")
        end

        # Finish
        runtime = Time.now - startTime
        puts "Parsor runtime was: " + runtime.to_s + " Seconds"
        puts "Parsing finished, returning to previous state..."
    end
# Programm running for M5P-Tree
#==========================================================================
#==========================================================================
elsif selectionVal == 2
    # pars M5P by Christopher Sauer, 2014

    # run not until choice is made
    if $choiceMade
        startTime = Time.now
        # running
        puts "0: Running M5P-Parser"

        # preParser
        #==========================================================================

        # Insert your filename
        printf "1: Enter Filename: "
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

        # Creating first outputfile
        out = File.open(outName, "w")

        # Display if file is writeable
        if File.writable?(fileName)
            puts "1: File is writeable, let's get it started!"
        end

        # Remove first lines? - not activated
        #printf "1: Would you like to remove the first lines (if not => comment)? (y,n) "
        ans = "y"
        #ans = gets.chomp

        # Linecounter Inputfile
        countIn = 1
        # Linecounter Outputfile
        countOut = 1

        # Do for each line
        inp.each do |line|
            if countIn <= 3 && ans == "n"
                # Put first three lines in comments
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

        # Close files
        inp.close
        out.close

        # Generate output
        puts "1: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # parsEquation
        #==========================================================================

        # Files ready for Work
        # out1.txt <= preParser
        puts "2: Parsing Equations"

        # Searchterm for Equations
        printf "2: Enter your prediction(label) (e.g. UmformgradMAX): "
        searchTerm = gets.chomp
        searchTermFound = false
        lineSearchTermFound = 0

        # Equationterm
        printf "2: Enter your modelname (e.g. LM for Linear Model): "
        eqName = gets.chomp

        # Filenames input
        inName = "out1.txt"
        eqsName = "M5Pequations.m"

        # Files
        inp = File.open(inName, "r+")
        eqs = File.open(eqsName, "w")

        # Linecounter Inputfile
        countIn = 1
        # Equationcounter
        countEq = 1

        # Stringsave
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
                    # silence console out in Matlab
                    eqs.printf(";")
                    eqs.printf("\n")
                    countEq += 1
                    addString = ""
                end
            end
            countIn += 1
        end

        # write to files
        puts "2: Writing to Files..."
        inp.close
        eqs.close
        # reopen input
        inp = File.open(inName, "r+")
        # Generate output
        puts "2: " + eqNum.to_s + " Equation(s) written to " + eqsName

        # reset Linecounter
        countIn = 1
        # save values in array
        sav = []
        i = 0
        # Find start of equations
        inp.each do |line|
            if line[searchTerm]
                sav[i] = countIn
                i += 1
            end
            countIn += 1
        end

        # equation found? (optional)
        #puts "Equation found on line " + sav[0].to_s

        # cut Equations from out1.txt, leads to out2.txt
        # But first let me (take) save a (sel)fi(l)e
        inp.close
        outName = "out2.txt"
        inp = File.open(inName, "r+")
        out = File.open(outName, "w")

        # reset Linecounter
        countIn = 1
        countOut = 1
        # Write to outputfile
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

        # Generating Output
        puts "2: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # ()remover
        #==========================================================================

        puts "3: Removing (...)"

        # Files ready for Work
        # M5Pequations.m <= parsEquation
        # out1.txt <= preParser
        # out2.txt <= ()remover

        # file handling
        inName = "out2.txt"
        outName = "out3.txt"

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Generate and open Files
        inp = File.open(inName, "r+")
        out = File.open(outName, "w")

        # cut line from '('
        inp.each do |line|
            if line["("]
                newline = line[0..(line.index('(') - 1)]
                out.puts(newline)
            else
                out.puts(line)
            end
            countIn +=1
        end

        # *sigh* Filehandling...
        inp.close
        out.close

        # Generate Output
        puts "3: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # ifElser (THE Brain)
        #==========================================================================

        # Files ready for Work
        # M5Pequations.m <= parsEquation
        # out1.txt <= preParser
        # out2.txt <= ()remover
        # out3.txt <= ifElser
        puts "4: Handling the if and elseif operators"

        # Inputfile
        inName = "out3.txt"

        # Outputfile - not activated
        #printf "4: Please enter the desired Name for my main output (e.g. out.m): "
        #outName = gets.chomp
        outName = "out.m"

        # First Char of Variable
        printf "4: Please enter the First Char of your Variables (e.g. X for X_T0_A0): "
        varChar = gets.chomp

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Generate and open Files
        inp = File.open(inName, "r+")
        out = File.open(outName, "w")

        # Array for line lengths
        lengths = []

        # Do for each line to get lengths
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

        # Safe positions of your variable for each line
        posVar = []

        # do this
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

        # Generate and open Files
        inp = File.open(inName, "r+")
        out = File.open(outName, "w")

        #ifCounter
        ifCounter = 0

        # Dodo - ifElser (works?)
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
            elsif posVar[countIn] < posVar[(countIn - 1)]
                difference = posVar[(countIn - 1)] - posVar[countIn]
                countToEnd = difference/3
                for i in 1..countToEnd
                    out.puts("end")
                    ifCounter -= 1
                end
                out.puts("elseif " + line)
            end
            countIn += 1
        end

        # ending all ifs (hope)
        for i in 1..ifCounter
            out.puts("end")
            countOut += 1
        end

        # *sigh* Filehandling...
        inp.close
        out.close

        # Generating output
        puts "4: Outputfile " + outName + " and " + countOut.to_s + " lines written"

        # Needed later for functionfile generation
        calcFile = outName


        # genMatFun
        #==========================================================================

        # Files ready for Work
        # M5Pequations.m <= parsEquation, genMatFun
        # out1.txt <= preParser
        # out2.txt <= ()remover
        # out3.txt <= ifElser
        # out.m <= generated from ifElser
        # varChar-variable for scanning for Variables
        puts "5: Generating matlab functions"

        # Files
        inName = "M5Pequations.m"

        # Generate and open Files
        inp = File.open(inName, "r+")

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Variable Array for your variables
        vars = []
        nVars = 0;

        # Infos for the user
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

        # Remove duplicate variables
        vars = vars.uniq
        if vars.length == 0
            puts "5: no Variables found!"
        else
            puts "5: " + vars.length.to_s + " Variable(s) found!"
        end

        # Set name of your function for matlab
        printf "5: Please enter your desired functionName for Matlab (e.g. myfun): "

        # Generate file for function
        functionName = gets.chomp
        outName = functionName + ".m"
        out = File.open(outName, "w")

        # print to file
        # first line
        out.printf "function [f] = " + functionName + "("
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

        # Generating output
        puts "5: Functionfile " + outName + " and " + countOut.to_s + " lines written"

        # Information for the user
        puts "5: Now use your generated Functionfile " + outName + " for simple Matlab Execution without variable handling for Matlab"

        # Ask if unused files should be deleted
        print "5: Should unused files be deleted? (y,n) "
        answer = gets.chomp

        if answer == "y"
            # Removing unused files
            File.delete("out1.txt")
            File.delete("out2.txt")
            File.delete("out3.txt")
        end


        # newout
        #==========================================================================

        # M5Pequations.m
        # out.m - merge?
        # myfun.m - merge?
        # optional implementation for matlab use of e.g. not your functionfile out.m
        printf "6: Do you want to use your solution as a variable in matlab? (y,n) "
        answerMagic = gets.chomp

        # testing
        if answerMagic == "y"
            puts "6: Generating new files..."
            # Files
            inName = calcFile
            outName = functionName + ".m"
            equationsName = "M5Pequations.m"

            # reset Linecounter
            countIn = 1
            countOut = 1

            # Launching Files
            inp = File.open(inName, "r+")
            out = File.open(outName, "w")

            # test new function
            out.printf "function [f] = " + outName[0..-3] + "("
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
            out.puts(equationsName[0..(equationsName.index(".")-1)] + ";")
            countOut += 1

            # newline
            out.puts("% This line is intentionally there")

            # write out + set f
            inp.each do |line|
                if line[eqName]
                    out.puts(line[0..(line.index(eqName) - 1)] + "f = " + line[line.index(eqName)..-2] + ";" + "\n")
                    countOut += 1
                else
                    out.puts(line)
                    countOut += 1
                end
                countIn += 1
            end

            # endfunction
            out.puts("end")
            countOut += 1

            # *sigh* Filehandling...
            inp.close
            out.close

            # Remove myfun.m and out.m - not activated
            #printf "6: Should not-needed Files, like " + functionName + ".m or " + inName + " be deleted? (y,n) "
            #answerDelete = gets.chomp
            answerDelete = "y"

            if answerDelete == "y"
                #File.delete(functionName + ".m")
                File.delete(inName)
            end

            # Generating output
            puts "6: Outputfile " + outName + " and " + countOut.to_s + " lines written"

            # Info
            puts "6: You can now use " + outName + " as a function for direct matlab use of your values"
        end

        # Finish
        runtime = Time.now - startTime
        puts "Parsor runtime was: " + runtime.to_s + " Seconds"
        puts "Parsing finished, returning to previous state..."
    end
# Programm running for M5Rules
#==========================================================================
#==========================================================================
elsif selectionVal == 3
    # pars M5Rules by Christopher Sauer, 2014

    # run not until choice is made
    if $choiceMade
        startTime = Time.now
        # running
        puts "0: Running M5Rules-Parser"


        # preParser
        #==========================================================================

        # Insert your filename
        printf "1: Enter Filename: "
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

        # Creating first outputfile
        out = File.open(outName, "w")

        # Display if file is writeable
        if File.writable?(fileName)
            puts "1: File is writeable, let's get it started!"
        end

        # First Char of Variable
        printf "1: Please enter the First Char of your Variables (e.g. X for X_T0_A0): "
        varChar = gets.chomp

        # Linecounter Inputfile
        countIn = 1
        # Linecounter Outputfile
        countOut = 1

        # Do for each line
        inp.each do |line|
            # remove first line
            if countIn > 4
                out.puts(line.tr(':|%','').to_s)
                countOut +=1
            end
            countIn += 1
        end

        # Close files
        inp.close
        out.close

        # Generate output
        puts "1: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # []remover
        #==========================================================================

        puts "2: Removing [...]"

        # Files ready for Work
        # out1.txt <= preParser
        # out2.txt <= []remover

        # file handling
        inName = "out1.txt"
        outName = "out2.txt"

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Generate and open Files
        inp = File.open(inName, "r+")
        out = File.open(outName, "w")

        # cut line from '['
        inp.each do |line|
            if line["["]
                newline = line[0..(line.index('[') - 1)]
                out.puts(newline)
                countOut += 1
            else
                out.puts(line)
                countOut += 1
            end
            countIn +=1
        end

        # *sigh* Filehandling...
        inp.close
        out.close

        # Generate Output
        puts "2: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # parsEquation
        #==========================================================================

        # Files ready for Work
        # out1.txt <= preParser
        # out2.txt <= []remover
        puts "3: Parsing Equations"

        # Searchterm for Equations
        printf "3: Enter your prediction(label) (e.g. UmformgradMAX): "
        searchTerm = gets.chomp
        searchTermFound = false
        lineSearchTermFound = 0

        # Equationterm
        eqName = "Rule"
        eqNameFound = 1

        # Filenames input
        inName = "out2.txt"
        eqsName = "M5Requations.m"

        # Files
        inp = File.open(inName, "r+")
        eqs = File.open(eqsName, "w")

        # Linecounter Inputfile
        countIn = 1
        # Equationcounter
        countEq = 1

        # Stringsave
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
                    # silence console out in Matlab
                    eqs.printf(";")
                    eqs.printf("\n")
                    countEq += 1
                    addString = ""
                end
            end
            countIn += 1
        end

        # write to files
        puts "3: Writing to Files..."
        inp.close
        eqs.close
        # reopen input
        inp = File.open(inName, "r+")
        # Generate output
        puts "3: " + eqNum.to_s + " Equation(s) written to " + eqsName

        # cut file to logic from out2.txt, leads to out3.txt
        # But first let me (take) save a (sel)fi(l)e
        inp.close
        outName = "out3.txt"
        inp = File.open(inName, "r+")
        out = File.open(outName, "w")

        # reset Linecounter
        countIn = 1
        countOut = 1
        i = 0
        # Write to outputfile
        inp.each do |line|
            if line[searchTerm]
                searchTermFound = true
                lineSearchTermFound = countIn
            elsif searchTermFound
                if line.length == 1
                    searchTermFound = false
                end
            elsif line["IF"]
                # do nothing
            elsif line["THEN"]
                # do nothing
            elsif line["Rule"]
                eqNameFound += 1
            else
                # put line, only if there is logic
                out.puts(line)
                countOut += 1
            end
            countIn += 1
        end

        # *sigh* Filehandling...
        inp.close
        out.close

        # Generating Output
        puts "3: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # ifElser (THE Brain)
        #==========================================================================

        # Files ready for Work
        # M5Requations.m <= parsEquation
        # out1.txt <= preParser
        # out2.txt <= []remover
        # out3.txt <= parsEquation
        puts "4: Handling the if and elseif operators"

        # files
        inName = "out3.txt"
        outName = "out.m"

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Generate and open Files
        inp = File.open(inName, "r+")
        out = File.open(outName, "w")

        #ifCounter
        ifCounter = 0

        # reset eqNum
        eqNum = 1

        # Dodo - ifElser (works?)
        inp.each do |line|
            if line[varChar]
                out.puts ("if " + line)
                ifCounter += 1
                countOut += 1
            elsif line.length == 1 && countIn > 1
                # count the number of Rules found
                if eqNameFound > 1
                    out.puts (eqName + eqNum.to_s)
                    eqNameFound -= 1
                end
                eqNum += 1
                countOut += 1
                for i in 1..ifCounter
                    out.puts("end")
                    ifCounter -= 1
                    countOut += 1
                end
                out.puts(" ")
                countOut += 1
            end
            countIn += 1
        end

        # *sigh* Filehandling...
        inp.close
        out.close

        # Generating output
        puts "4: Outputfile " + outName + " and " + countOut.to_s + " lines written"

        # Needed later for functionfile generation
        calcFile = outName

        # genMatFun
        #==========================================================================

        # Files ready for Work
        # M5Requations.m <= parsEquation
        # out1.txt <= preParser
        # out2.txt <= []remover
        # out3.txt <= parsEquation
        # out.m <= generated from ifElser
        # varChar-variable for scanning for Variables
        puts "5: Generating matlab functions"

        # Files
        inName = "M5Requations.m"

        # Generate and open Files
        inp = File.open(inName, "r+")

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Variable Array for your variables
        vars = []
        nVars = 0;

        # Infos for the user
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

        # Remove duplicate variables
        vars = vars.uniq
        if vars.length == 0
            puts "5: no Variables found!"
        else
            puts "5: " + vars.length.to_s + " Variable(s) found!"
        end

        # Set name of your function for matlab
        printf "5: Please enter your desired functionName for Matlab (e.g. myfun): "

        # Generate file for function
        functionName = gets.chomp
        outName = functionName + ".m"
        out = File.open(outName, "w")

        # print to file
        # first line
        out.printf "function [f] = " + functionName + "("
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

        # Generating output
        puts "5: Functionfile " + outName + " and " + countOut.to_s + " lines written"

        # Information for the user
        puts "5: Now use your generated Functionfile " + outName + " for simple Matlab Execution without variable handling for Matlab"

        # Ask if unused files should be deleted
        print "5: Should unused files be deleted? (y,n) "
        answer = gets.chomp

        if answer == "y"
            # Removing unused files
            File.delete("out1.txt")
            File.delete("out2.txt")
            File.delete("out3.txt")
        end

        # newout
        #==========================================================================

        # M5Requations.m
        # out.m - merge?
        # myfun.m - merge?
        # optional implementation for matlab use of e.g. not your functionfile out.m
        printf "6: Do you want to use your solution as a variable in matlab? (y,n) "
        answerMagic = gets.chomp

        # testing
        if answerMagic == "y"
            puts "6: Generating new files..."
            # Files
            inName = calcFile
            outName = "new" + functionName + ".m"
            equationsName = "M5Requations.m"

            # reset Linecounter
            countIn = 1
            countOut = 1

            # Launching Files
            inp = File.open(inName, "r+")
            out = File.open(outName, "w")

            # test new function
            out.printf "function [f] = " + outName[0..-3] + "("
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
            out.puts(equationsName[0..(equationsName.index(".")-1)] + ";")
            countOut += 1

            # newline
            out.puts("% This line is intentionally there")

            # write out + set f
            inp.each do |line|
                if line[eqName]
                    out.puts(line[0..(line.index(eqName) - 1)] + "f = " + line[line.index(eqName)..-2] + ";" + "\n")
                    countOut += 1
                else
                    out.puts(line)
                    countOut += 1
                end
                countIn += 1
            end

            # endfunction
            out.puts("end")
            countOut += 1

            # *sigh* Filehandling...
            inp.close
            out.close

            # Remove myfun.m and out.m - not activated
            #printf "6: Should not-needed Files, like " + functionName + ".m or " + inName + " be deleted? (y,n) "
            #answerDelete = gets.chomp
            answerDelete = "y"

            if answerDelete == "y"
                File.delete(functionName + ".m")
                File.delete(inName)
            end

            # Generating output
            puts "6: Outputfile " + outName + " and " + countOut.to_s + " lines written"

            # Info
            puts "6: You can now use " + outName + " as a function for direct matlab use of your values"
        end

        # Finish
        runtime = Time.now - startTime
        puts "Parsor runtime was: " + runtime.to_s + " Seconds"
        puts "Parsing finished, returning to previous state..."
    end
# Programm running for Polynom Regression
#==========================================================================
#==========================================================================
elsif selectionVal == 4
    # pars PolReg by Christopher Sauer, 2014

    # run not until choice is made
    if $choiceMade
        startTime = Time.now
        # running
        puts "0: Running PolReg-Parser"


        # preParser
        #==========================================================================

        # Insert your filename
        printf "1: Enter Filename: "
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

        # Creating first outputfile
        out = File.open(outName, "w")

        # Display if file is writeable
        if File.writable?(fileName)
            puts "1: File is writeable, let's get it started!"
        end

        # First Char of Variable
        printf "1: Please enter the First Char of your Variables (e.g. X for X_T0_A0): "
        varChar = gets.chomp

        # Linecounter Inputfile
        countIn = 1
        # Linecounter Outputfile
        countOut = 1

        # Do for each line
        inp.each do |line|
            # remove first line
            if countIn > 2
                out.puts(line)
                countOut +=1
            elsif countIn == 2
                out.puts(line[20..-1])
                countOut += 1
            end
            countIn += 1
        end

        # Close files
        inp.close
        out.close

        # Generate output
        puts "1: Outputfile " + outName + " and " + countOut.to_s + " lines written"


        # parsEquation
        #==========================================================================

        # Files ready for Work
        # out1.txt <= preParser
        puts "2: Parsing polReg Equation"

        # vars for this operation
        eqName = "PR"
        equationString = ""

        # Filenames input
        inName = "out1.txt"
        eqsName = "PRequation.m"

        # Files
        inp = File.open(inName, "r+")
        eqs = File.open(eqsName, "w")

        # Linecounter Inputfile
        countIn = 1

        # write first line
        equationString = eqName + " = "
        eqs.printf(equationString)

        # Do for each line
        inp.each do |line|
            equationString << (line[0..-3] + " ")
            countIn += 1
        end

        # silence output
        equationString << ";"

        # write in output
        eqs.puts(equationString)

        # write to files
        puts "2: Writing to Files..."
        inp.close
        eqs.close

        # Generate output
        puts "2: Equation written to " + eqsName


        # genMatFun
        #==========================================================================

        # Files ready for Work
        # PRequation.m <= parsEquation, genMatFun
        # out1.txt <= preParser

        # varChar-variable for scanning for Variables
        puts "3: Generating matlab function"

        # Files
        inName = "PRequation.m"

        # Generate and open Files
        inp = File.open(inName, "r+")

        # reset Linecounter
        countIn = 1
        countOut = 1

        # Variable Array for your variables
        vars = []
        nVars = 0;

        # Infos for the user
        puts "3: Starting variable search"

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

        # Remove duplicate variables
        vars = vars.uniq
        if vars.length == 0
            puts "3: no Variables found!"
        else
            puts "3: " + vars.length.to_s + " Variable(s) found!"
        end

        # Set name of your function for matlab
        printf "3: Please enter your desired functionName for Matlab (e.g. myfun): "

        # Generate file for function
        functionName = gets.chomp
        outName = functionName + ".m"

        # Opening
        out = File.open(outName, "w")

        # print to file
        # first line
        out.printf "function [" + eqName +"] = " + functionName + "("
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
        # insert equation
        out.puts(equationString)

        # endfunction
        out.puts("end")
        countOut += 1

        # *sigh* Filehandling...
        inp.close
        out.close

        # Generating output
        puts "3: Functionfile " + outName + " and " + countOut.to_s + " lines written"

        # Information for the user
        puts "3: Now use your generated Functionfile " + outName + " for simple Matlab Execution with variable handling for Matlab"

        # Ask if unused files should be deleted
        print "3: Should unused files be deleted? (y,n) "
        answer = gets.chomp

        if answer == "y"
            # Removing unused files
            File.delete("out1.txt")
        end

        # Finish
        runtime = Time.now - startTime
        puts "Parsor runtime was: " + runtime.to_s + " Seconds"
        puts "Parsing finished, returning to previous state..."
    end
#==========================================================================
#==========================================================================
elsif selectionVal == 666
    puts "The Number of the Beast!"
end
