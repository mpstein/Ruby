###############################################################################
##                              ZipStats                                     ##
##                   Reads in Sales info and outputs stats                   ##
##  												Using Ruby 1.8.7                								 ##
###############################################################################


###############################################################################
##                             Output Format: 								               ##
## zipcode,average,median,totalsold,month-value             			        	 ##
###############################################################################

#Explain that this could have issues if there was dates in 2013, duplicate month

require 'rubygems'
require 'FasterCSV'

raise "Please specify both the input and output files." unless ARGV.length == 2
raise "Please specify a legit input file" unless File.exists?(ARGV[0])

inPath =  ARGV[0]
outPath = ARGV[1]

#Populate Data Hashes
priceData = {}
monthData = {}
FasterCSV.foreach(inPath, :headers => true) do |row|  
	currentZip = row[4][0,5]
  unless currentZip.size == 4
   	currentMonth = row[1].split("-")[1]
    currentPrice = row[3]

    priceData[currentZip] ||= []
    priceData[currentZip] << currentPrice.to_i
    monthData[currentZip] ||= []
    monthData[currentZip] << currentMonth.to_i
  end
end

#Start Building Output String with Stat Data
output_file = {}  
priceData.each{ |zipc, row|
  rowSize = row.size
  mPoint = rowSize / 2
  average = ((row.inject(&:+)) / (rowSize.to_f))
  median = (rowSize % 2 != 0 ? row.sort[mPoint] : ((row.sort[mPoint] + row.sort[mPoint-1]) / 2.0))
  output_file[zipc] ||= []
  output_file[zipc] << "#{zipc},#{(average * 100).round / 100.0},#{(median * 100).round / 100.0},#{row.size},"
}

#Calculate Month Frequncies
monthFreq = {}
monthData.each{ |zipc, month|
  monthFreq[zipc] ||= []
  monthFreq[zipc] = month.each.inject(Hash.new(0)) do |saleMonth, count|
  	saleMonth[count] +=1
  	saleMonth
  end
  
  monthFreq[zipc] = monthFreq[zipc].sort
	output_file[zipc] = "#{output_file[zipc]}#{(monthFreq[zipc].inspect).gsub!(/\s*\[+\s*(\d+), (\d+)\]+\s*/, '\1-\2')}"
}

#Output Header and then string to output file
File.open(outPath, "w") do |file|
  file.puts('Zipcode,Average,Median,Qty,Month-Value')
	output_file.each{ |zipc, outString|
		file.puts(output_file[zipc])
	}
end

puts "Done! Please check out " + ARGV[1] + " for your statistics"