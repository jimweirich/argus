require 'spec_helper'
require 'time'

describe TimeQueue do
  Given(:time) { Time.now }
  Given(:tq) { TimeQueue.new }

  context "with an empty queue" do
    Then { ! tq.any_ready?(time+100) }
  end

  context "with several items" do
    Given {
      tq.add(time, :zero)
      tq.add(time+2, :two)
      tq.add(time+1, :one)
    }
    Then { ! tq.any_ready?(time-1) }
    Then { tq.any_ready?(time) }

    Then { tq.all_ready(time-1) == [] }
    Then { tq.all_ready(time  ) == [:zero] }
    Then { tq.all_ready(time+1) == [:zero, :one] }
    Then { tq.all_ready(time+2) == [:zero, :one, :two] }
  end

  describe "#to_s" do
    Given(:time) { Time.parse("12:00:00") }
    Given(:items) { [ ] }
    Given {
      items.each.with_index do |item, i| tq.add(time+i, item) end
    }

    context "with no items" do
      Then { tq.to_s == "[]" }
    end

    context "with one item" do
      Given(:items) { [ :zero ] }
      Then { tq.to_s == "[:zero@12:00:00.000]" }
    end

    context "with four items" do
      Given(:items) { [ :zero, :one, :two, :three ] }
      Then { tq.to_s == "[:zero@12:00:00.000, :one@+1.0, :two@+2.0, ...]" }
    end
  end

  describe "removing items" do
    Given {
      tq.add(time, :zero)
      tq.add(time+2, :two)
    }
    Given!(:onekey) { tq.add(time+1, :one) }

    When { tq.remove(onekey) }
    let(:result) { tq.all_ready(time+100) }

    Then { result == [:zero, :two] }
  end
end
