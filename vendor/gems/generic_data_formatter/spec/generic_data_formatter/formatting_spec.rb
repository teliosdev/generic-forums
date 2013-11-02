describe GenericDataFormatter do
  it { should respond_to :add_formatter }
  it { should respond_to :format }

  before :each do
    GenericDataFormatter.reset!
  end

  it "adds a formatter" do
    block = proc { throw :hello }
    GenericDataFormatter.add_formatter :something, &block
    expect(GenericDataFormatter.formatter(:something)).to be block
  end

  it "formats correctly" do
    block = proc { |body| "hello" }
    GenericDataFormatter.add_formatter :something, &block
    expect(GenericDataFormatter.format(:something, "test")).to eq "hello"
  end
end
