require 'open-uri'
require 'net/http'
require 'nokogiri'

class TSAdata
  attr_reader :airportname,:checkpoints
  
  def initialize airportcode
    xml_airport_data = open('http://www.tsa.gov/data/apcp.xml') {|f| f.read}
    ng_airport_data = Nokogiri::XML(xml_airport_data)

    airport = ng_airport_data.xpath("//airport[shortcode='#{airportcode}']").at_xpath("name")
    
    raise "Invalid Airport" if airport.nil? 
    
    @airportname = airport.text
    
    @checkpoints = {}
    ng_airport_data.xpath("//airport[shortcode='#{airportcode}']/checkpoints/checkpoint").each do |node|
      @checkpoints[node.at_xpath("id").text.to_i]=node.at_xpath("longname").text  
    end
    
    waittimesurl = "http://apps.tsa.dhs.gov/MyTSAWebService/GetWaitTimes.ashx?ap=#{airportcode}"
    
    begin
      data = Net::HTTP.get_response(URI.parse(waittimesurl)).body
    rescue
      print "connection error"
    end

    wait_data = Nokogiri::XML(data)
    
    @waittimes = []
    
    wait_data.xpath("//WaitTimes").each do |node|
      a = {}
      a[:checkpoint] = @checkpoints[node.at_xpath("CheckpointIndex").text.to_i]
      a[:wait] = node.at_xpath("WaitTimeIndex").text.to_i
      a[:date] = Date.rfc3339(node.at_xpath("Created_Datetime").text)
      @waittimes << a unless a[:checkpoint].nil?
    end
    
    @waittimes.sort_by! {|hash| hash[:date]}
    
  end
  
  def recentwaits
   recentwaits = {}
   @waittimes.each do |waithash|
     recentwaits[waithash[:checkpoint]] = waithash[:wait]
   end
   recentwaits
  end
  
end

class TSAreport
  attr_reader :airport_report
  
  def initialize airports
    @airport_report = {}
    airports.each do |airport|
      current_airport_data = TSAdata.new(airport)
      @airport_report[airport.to_sym] = [current_airport_data.airportname,current_airport_data.recentwaits]
    end
  end
  
  def writereport filename
    f = File.open(filename,'w')
    f.puts "************  AIRPORT SECURITY CHECKPOINT WAIT REPORT ************"
    f.puts ""
    @airport_report.each do |shortcode, array|
      f.puts shortcode.to_s + " / " + array[0]+":"
      array[1].each do |checkpoint,wait|
        minstring = (wait == 1) ? " minute" : " minutes"
        f.puts "  " + checkpoint + ": " + wait.to_s + minstring
      end
    end
    f.close
  end
end