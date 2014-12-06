require "#{File.dirname(__FILE__)}/tsadata"

describe TSAdata do
  before(:all) do
    @seatac = TSAdata.new("SEA")
    @ca = TSAreport.new ['SFO','LAX']
  end
  
  it "returns an error when an invalid airport is passed" do
    expect{TSAdata.new("XXX")}.to raise_error('Invalid Airport')
  end
  
  it "should get the airport name when a shortcode is passed" do
    expect(@seatac.airportname).to eq("Seattle-Tacoma International")
  end
  
  it "should have a hash of checkpoints" do
    seattlecheckpoints = {1=>"South Checkpoint",2=>"Central Checkpoint",3=>"Charlie Checkpoint",4=>"North Checkpoint",5=>"FIS Checkpoint"}
    expect(@seatac.checkpoints).to eq(seattlecheckpoints)
  end
  
  it "should have an array of arrays of wait time data" do
    expect(@seatac.recentwaits).to be_instance_of(Hash)
    expect(@seatac.recentwaits["South Checkpoint"]).to be_instance_of(Fixnum)
  end
  
  it "should initialize TSAreport objects successfully" do

    expect(@ca).to be_instance_of(TSAreport)
    expect(@ca.airport_report[:SFO][0]).to eq("San Francisco International")
  end
  
  it "should allow TSAreport objects to create an airport report" do
    @ca.writereport "reporttest.txt"
    expect(File).to exist("reporttest.txt")
  end
  
end