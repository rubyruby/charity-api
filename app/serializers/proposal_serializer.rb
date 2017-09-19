class ProposalSerializer < ActiveModel::Serializer
  attributes :index,
             :address,
             :amount,
             :text,
             :dueTime,
             :isFinished,
             :isPassed,
             :hasVoted,
             :yesCount,
             :noCount

  def dueTime
    object.due_time
  end

  def isFinished
    object.finished?
  end

  def isPassed
    object.passed?
  end

  def hasVoted
    object.voted?
  end

  def yesCount
    object.yes_count
  end

  def noCount
    object.no_count
  end
end
