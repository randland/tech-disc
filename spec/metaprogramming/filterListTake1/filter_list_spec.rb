require_relative '../../metaprogramming/filter_list'
require 'ostruct'

RSpec.describe FilterList do
  describe '#initialize' do
    it 'takes an array of objects' do
      list = described_class.new([1, 2, 3])
      expect(list.to_a).to eq([1, 2, 3])
    end

    it 'takes a list of objects' do
      list = described_class.new(1, 2, 3)
      expect(list.to_a).to eq([1, 2, 3])
    end
  end

  describe "#respond_to?" do
    it "returns true if the attribute exists" do
      list = described_class.new(
        OpenStruct.new(id: 1, foo: 2)
      )

      expect(list.respond_to?(:id_is)).to be
      expect(list.respond_to?(:foo_is)).to be
      expect(list.respond_to?(:bar_is)).to_not be
    end

    it "returns true if _any_ objects have that attribute" do
      list = described_class.new(
        nil,
        OpenStruct.new(id: 1, foo: 2)
      )

      expect(list.respond_to?(:id_is)).to be
      expect(list.respond_to?(:foo_is)).to be
      expect(list.respond_to?(:bar_is)).to_not be
    end
  end

  describe 'filtering' do
    let(:obj_class) { Struct.new(:num, :date, :string) }
    let(:now) { Time.now }
    let(:day) { 60 * 60 * 24 }
    let(:obj1) { obj_class.new(num: 1, date: now + 1 * day, string: 'foo bar') }
    let(:obj2) { obj_class.new(num: 3, date: now + 2 * day, string: 'bar baz') }
    let(:obj3) { obj_class.new(num: 5, date: now + 3 * day, string: 'hello') }
  end

  describe '#id_is' do
    it 'filters the list by id' do
      objs = [
        OpenStruct.new(id: 1),
        OpenStruct.new(id: 2),
        OpenStruct.new(id: 3)
      ]
      list = described_class.new(objs)
      result = list.id_is(2)

      expect(result.to_a).to eq([objs[1]])
    end

    it "filters the list by id, even if some objects don't have that" do
      objs = [
        nil,
        OpenStruct.new(id: 1),
        OpenStruct.new(id: 2),
        OpenStruct.new(id: 3)
      ]
      list = described_class.new(objs)
      result = list.id_is(2)

      expect(result.to_a).to eq([objs[2]])
    end

    context 'not:' do
      it "returns items that don't have the id" do
        objs = [
          OpenStruct.new(id: 1),
          OpenStruct.new(id: 2),
          OpenStruct.new(id: 3)
        ]
        list = described_class.new(objs)
        result = list.id_is(not: 2)

        expect(result.to_a).to eq([objs[0], objs[2]])
      end

      it "returns items that don't have the id or any id" do
        objs = [
          OpenStruct.new(foo: :bar),
          OpenStruct.new(id: 1),
          OpenStruct.new(id: 2),
          OpenStruct.new(id: 3)
        ]
        list = described_class.new(objs)
        result = list.id_is(not: 2)

        expect(result.to_a).to eq([objs[0], objs[1], objs[3]])
      end
    end

    context 'gt:' do
      it "returns items that have id greater than" do
        objs = [
          OpenStruct.new(id: 1),
          OpenStruct.new(id: 2),
          OpenStruct.new(id: 3)
        ]
        list = described_class.new(objs)
        result = list.id_is(gt: 1)

        expect(result.to_a).to eq([objs[1], objs[2]])
      end

      it "returns items that have id at all greater than" do
        objs = [
          OpenStruct.new(foo: :bar),
          OpenStruct.new(id: 1),
          OpenStruct.new(id: 2),
          OpenStruct.new(id: 3)
        ]
        list = described_class.new(objs)
        result = list.id_is(gt: 1)

        expect(result.to_a).to eq([objs[2], objs[3]])
      end
    end
  end

  describe '#foo_is' do
    it 'filters the list by foo' do
      objs = [
        OpenStruct.new(foo: 1),
        OpenStruct.new(foo: 2),
        OpenStruct.new(foo: 3)
      ]
      list = described_class.new(objs)
      result = list.foo_is(2)

      expect(result.to_a).to eq([objs[1]])
    end

    context 'not:' do
      it "returns items that don't have the foo" do
        objs = [
          OpenStruct.new(foo: 1),
          OpenStruct.new(foo: 2),
          OpenStruct.new(foo: 3)
        ]
        list = described_class.new(objs)
        result = list.foo_is(not: 2)

        expect(result.to_a).to eq([objs[0], objs[2]])
      end
    end

    context 'gt:' do
      it "returns items that don't have the foo" do
        objs = [
          OpenStruct.new(foo: 1),
          OpenStruct.new(foo: 2),
          OpenStruct.new(foo: 3)
        ]
        list = described_class.new(objs)
        result = list.foo_is(gt: 1)

        expect(result.to_a).to eq([objs[1], objs[2]])
      end
    end

    context 'range' do
      it 'returns items in the range' do
        objs = [
          OpenStruct.new(foo: 1),
          OpenStruct.new(foo: 2),
          OpenStruct.new(foo: 3)
        ]
        list = described_class.new(objs)
        result = list.foo_is(1..2)

        expect(result.to_a).to eq([objs[0], objs[1]])
      end
    end

    context 'regular expression' do
      it "returns elements that match the regular expression" do
        objs = [
          OpenStruct.new(xyz: "string"),
          OpenStruct.new(foo: 1),
          OpenStruct.new(foo: "string"),
          OpenStruct.new(foo: "strong"),
          OpenStruct.new(foo: "stung")
        ]

        list = described_class.new(objs)
        result = list.foo_is(/^str/)

        expect(result.to_a).to eq([objs[2], objs[3]])
      end
    end
  end
end
