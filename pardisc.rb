# Enable parsing of discrete Values for Parsor
# by Christopher Sauer, 2014

# Variables
outName = "out1.txt"
countOut = 0
lineEqStart = 0
i = 0
vars = []

# Filename
printf "1: Enter functionname: "
funcName = gets.chomp

# Filehandling
begin
    inp = File.open(funcName, "r+")
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
if File.writable?(funcName)
    puts "1: File is writeable, let's get it started!"
end

# Count where equations start
inp.each do |line|
    # write vars
    vars[i] = line
    if line["% Equations"]
        lineEqStart = i - 1
    end
    i += 1
end

# Write to file
for i in 0..lineEqStart
    if i > 0
        out.puts(vars[i])
    end
end

# Filehandling
inp.close
out.close
