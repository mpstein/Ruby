###############################################################################
##                              ZipStats                                     ##
##                   Reads in Sales info and outputs stats                   ##
##  												Using Ruby 1.8.7                								 ##
###############################################################################


###############################################################################
##                             Output Format: 								               ##
## "zipcode,average,median,totalsold,month-value"           			        	 ##
###############################################################################

#Explain that this could have issues if there was dates in 2013, duplicate month

require 'rubygems'
require 'FasterCSV'

raise "Please specify both the input and output files." unless ARGV.length == 2
raise "Please specify a legit input file" unless File.exists?(ARGV[0])

inPath =  ARGV[0]
outPath = ARGV[1]

dataHash = {:prices =>[], :month_count => []}
priceData = {}
monthData = {}

FasterCSV.foreach(inPath, :headers => true) do |row|  
	currentZip = row[4][0,5]
  unless currentZip.size == 4
   	currentMonth = row[1].split("-")[1]
    currentPrice = row[3]

    dataHash[currentZip] ||= []
    dataHash[currentZip][:prices] << currentPrice.to_i
    dataHash[currentZip][:month_count] << currentMonth.to_i
  end
end
=begin

end
#Start Building Output String with Stat Data
output_file = {}
priceData.each{ |zipc, row|
  rowSize = row.size
  mPoint = rowSize / 2
  average = ((row.inject(&:+)) / (rowSize.to_f))
  median = (rowSize % 2 != 0 ? row.sort[mPoint] : ((row.sort[mPoint] + row.sort[mPoint-1]) / 2.0))
  output_file[zipc] ||= []
  output_file[zipc] << "#{zipc},#{average},#{median},#{row.size},"
}

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

FasterCSV.open(outPath, "w") do |csv|
  csv << "Zipcode,Average,Median,Qty,Month-Value"
	output_file.each{ |zipc, outString|
		csv << output_file[zipc]
	}
end
=end
puts "Done! Please check out " + ARGV[1] + " for your statistics"