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
    eqsName = "equation.m"

    # Files
    inp = File.open(inName, "r+")
    eqs = File.open(eqsName, "w")

    # Linecounter Inputfile
    countIn = 1

    # write first line
    eqs.printf(eqName + " = ")

    # Do for each line
    inp.each do |line|
        eqs.printf(line[0..-3])
        countIn += 1
    end

    # silence output
    eqs.printf(";")

    # write to files
    puts "2: Writing to Files..."
    inp.close
    eqs.close

    # Generate output
    puts "2: Equation written to " + eqsName
end
