RSpec.describe Pinger::Parser do
  it "sets the right parameters" do
    args = []
    parser = Pinger::Parser.new(args)

    expect(parser.args).not_to be nil
    expect(parser.args).to be args
  end

  it "set the default params" do
    args = ['www.example.com']
    parser = Pinger::Parser.new(args)


    options, _ = parser.parse!

    expect(options[:interval]).to eq 10
    expect(options[:duration]).to eq 60
  end

  it "sets the passed params" do
    args = ["-i", "1", "-d", "10", "www.example.com"]
    parser = Pinger::Parser.new(args)

    options, _ = parser.parse!

    expect(options[:interval]).to eq 1
    expect(options[:duration]).to eq 10
  end

  it "respects the a valid protocol based url" do
    args = ['https://www.example.com']
    parser = Pinger::Parser.new(args)

    _, website = parser.parse!

    expect(website).to eq "https://www.example.com"
  end

  it "adds a default protocol" do
    args = ['www.example.com']
    parser = Pinger::Parser.new(args)

    _, website = parser.parse!

    expect(website).to eq "http://www.example.com"
  end
end
