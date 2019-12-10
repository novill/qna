# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      # puts __method__, user.inspect, '===='
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :answers, Question
  end

  def admin_abilities
    can :manage, :all
    can [:update, :destroy], [Question, Answer, Link]
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Link, Subscription]
    can [:update, :destroy], [Question, Answer, Link] do |thing|
      @user.author_of?(thing)
    end

    can :destroy, ActiveStorage::Attachment, [Question, Answer] do |attachable|
      user.author_of?(attachable)
    end

    can :destroy, Subscription, user_id: user.id


    can [:upvote, :downvote], [Question, Answer] do |votable|
      !user.author_of?(votable) && !votable.votes.exists?(user_id: user.id)
    end

    can [:vote_back], [Question, Answer] do |votable|
      votable.votes.exists?(user_id: user.id)
    end


    can :set_as_best, Answer, question: { user_id: user.id }
  end
end
