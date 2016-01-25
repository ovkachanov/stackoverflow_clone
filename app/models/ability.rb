class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    alias_action  :create, :edit, :update, :destroy, to: :crud

    can :crud, [Question, Answer], user: user

    can :create, Comment

    can :me, User, id: user.id

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

    alias_action :up, :down, :unvote, to: :vote
    can :vote, [Question, Answer] { |vote| user.non_author_of?(vote) }
  end
end
