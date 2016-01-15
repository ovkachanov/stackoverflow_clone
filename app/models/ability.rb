class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    alias_action  :create, :read, :update, :destroy, to: :crud

    can :crud, [Question, Answer], user: user

    can :create, Comment

    can :best, Answer do |answer|
      answer.question.user_id == user.id && answer.user_id != user.id
    end

    can :manage, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end

     can [:up, :down], Vote do |vote|
      vote.votable.user_id != user.id
    end

    can :unvote, Vote, user: user
  end
end
