puts File.join(__dir__.gsub("/spec", ""), File.basename(__FILE__).gsub("_spec.rb", ""))
require 'ostruct'

RSpec.describe FilterList do
  it "works" do
    expect(FilterList.new).to be
  end
end
