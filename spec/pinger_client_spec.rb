RSpec.describe Pinger::Client do
  it "sets the right parameters" do
    client = Pinger::Client.new('https://www.facebook.com', 60, 10)
    expect(client.website).to eq "https://www.facebook.com"
    expect(client.duration).to eq 60
    expect(client.interval).to eq 10
  end

  it "computes the mean response time" do
    # TODO: this can be made more solid, come back
    # stub the benchmark_request method
    allow_any_instance_of(Pinger::Client).to receive(:benchmark_request).and_return(100)
    client = Pinger::Client.new('https://www.facebook.com', 5, 1)


    mean_time = client.compute_mean_response
    expect(mean_time).to eq 100
  end
end
