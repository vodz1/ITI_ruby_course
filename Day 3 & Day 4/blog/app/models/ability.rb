# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user

    can :read, Article

    can :manage, Article, user_id: user.id

    if user.admin?
      can :manage, Article
    end
  end
end
