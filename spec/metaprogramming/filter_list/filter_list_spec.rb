require File.join(__dir__.gsub("/spec", ""), File.basename(__FILE__).gsub("_spec.rb", ""))
require 'ostruct'

RSpec.describe FilterList do
  describe "#initialize" do
    it "works if provided no items" do
      list = described_class.new()
      expect(list).to_not be_nil
      expect(list).to be_empty
    end

    it "works if provided one item" do
      list = described_class.new(:a)
      expect(list.count).to eq(1)
    end

    it "works if provided a list of items, comma separated" do
      list = described_class.new(:a, :b)
      expect(list.count).to eq(2)
    end

    it "works if provided a list of items, as an array" do
      list = described_class.new([:a, :b])
      expect(list.count).to eq(2)
    end
 end

  describe "#first" do
    it "returns the first element" do
      list = described_class.new(:a, :b)
      expect(list.first).to eq(:a)
    end
  end

  describe "#is_XXX" do
    it "filters the list by XXX" do
      list = described_class.new(1, 2, 3)
      filtered = list.is_odd
      expect(filtered.count).to eq(2)
      expect(filtered.to_a).to eq([1, 3])
    end

    it "filters by XXX, even if some things don't respond to it" do
      list = described_class.new(1, 2, 3, :a)
      filtered = list.is_odd
      expect(filtered.count).to eq(2)
      expect(filtered.to_a).to eq([1, 3])
    end

    it "filters the list by NOT XXX" do
      list = described_class.new(1, 2, 3)
      filtered = list.is_not_odd
      expect(filtered.count).to eq(1)
      expect(filtered.to_a).to eq([2])
    end

    it "filters by NOT XXX, even if some things don't respond to it" do
      list = described_class.new(1, 2, 3, :a)
      filtered = list.is_not_odd
      expect(filtered.count).to eq(2)
      expect(filtered.to_a).to eq([2, :a])
    end
  end
end
