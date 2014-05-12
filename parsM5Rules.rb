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

    # Filenames input
    inName = "out2.txt"
    eqsName = "equations.m"

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
            # do nothing
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
    # equations.m <= parsEquation
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
    ifCounter = 1

    # reset eqNum
    eqNum = 1

    # Dodo - ifElser (works?)
    inp.each do |line|
        if line[varChar]
            out.puts ("if " + line)
            ifCounter += 1
            countOut += 1
        elsif line.length == 1 && countIn > 1
            out.puts (eqName + eqNum.to_s)
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
end
