describe "memory style class" do

  it "initializes attributes to empty arrays" do
    s = OrigenTesters::MemoryStyle.new()
    s.pin_id.should == []
    s.size.should == []
    s.bit_order.should == []
    s.format.should == []
    s.trigger.should == []
  end
  
  it "correctly adds only pin id" do
    s = OrigenTesters::MemoryStyle.new()
    s.pin :dummy_pin
    s.pin_id.should == [[:dummy_pin]]
    s.size.should == [nil]
    s.bit_order.should == [nil]
    s.format.should == [nil]
    s.trigger.should == [nil]
  end
  
  it "correctly adds pin id and single attribute" do
    s = OrigenTesters::MemoryStyle.new()
    s.pin :dummy_pin, size: 8
    s.pin_id.should == [[:dummy_pin]]
    s.size.should == [8]
    s.bit_order.should == [nil]
    s.format.should == [nil]
    s.trigger.should == [nil]
  end
  
  it "correctly adds pin id and multiple attributes" do
    s = OrigenTesters::MemoryStyle.new()
    s.pin :dummy_pin, size: 8, format: :long
    s.pin_id.should == [[:dummy_pin]]
    s.size.should == [8]
    s.bit_order.should == [nil]
    s.format.should == [:long]
    s.trigger.should == [nil]
  end
  
  it "correctly sets attributes for multiple pins" do
    s = OrigenTesters::MemoryStyle.new()
    s.pin :dummy_1, :dummy_2, size: 8
    s.pin_id.should == [[:dummy_1, :dummy_2]]
    s.size.should == [8]
    s.bit_order.should == [nil]
    s.format.should == [nil]
    s.trigger.should == [nil]
  end

  it "correctly accumulates" do
    s = OrigenTesters::MemoryStyle.new()
    s.pin :dummy_pin, size: 8, format: :long
    s.pin :dummy_pin2
    s.pin :dummy_pin2, size: 1
    s.pin :dummy_pin2, size: 2
    s.accumulate_attributes(:dummy_pin2).should == {pin_id: :dummy_pin2, size: 2, bit_order: nil, format: nil, trigger: nil}
  end
  
  it "correctly identifies contained pins" do
    s = OrigenTesters::MemoryStyle.new()
    s.pin :dummy_pin, size: 8, format: :long
    s.pin :dummy_pin2
    s.contains_pin?(:dummy_pin).should == true
    s.contains_pin?(:dummy_pin2).should == true
    s.contains_pin?(:not_there).should == false
    s.contained_pins.should == [:dummy_pin, :dummy_pin2]
  end
  
end