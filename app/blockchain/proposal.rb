class Proposal
  include ActiveModel::Serialization
  attr_reader :index, :address, :amount, :text, :due_time

  def initialize(proposal, index)
    @index = index
    @address = "0x#{proposal[0]}"
    @amount = Ethereum::Formatter.new.from_wei(proposal[1])
    @text = proposal[2]
    @due_time = Time.at(proposal[3])
    @finished = proposal[4]
    @passed = proposal[5]
    @voted = proposal[8] != 0
    @votes_count = proposal[6]
    @votes_sum = proposal[7]
  end

  def yes_count
    (@votes_count + @votes_sum) / 2
  end

  def no_count
    (@votes_count - @votes_sum) / 2
  end

  def finished?
    @finished
  end

  def passed?
    @passed
  end

  def voted?
    @voted
  end
end
