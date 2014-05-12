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
    eqsName = "equation.m"

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
    # equation.m <= parsEquation, genMatFun
    # out1.txt <= preParser

    # varChar-variable for scanning for Variables
    puts "3: Generating matlab function"

    # Files
    inName = "equation.m"

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
