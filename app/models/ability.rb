# frozen_string_literal: true

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
    can :create, [Question, Answer, Comment, Link]
    can [:update, :destroy], [Question, Answer, Link], user_id: user.id
    can [:upvote, :downvote, :vote_back], [Question, Answer]
    can :set_as_best, Answer, question: { user_id: user.id }
  end
end
