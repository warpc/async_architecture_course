class User < ApplicationRecord
  has_many :tasks, foreign_key: 'creator_id'
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assigned_to_id'
  has_many :auth_identities

  def self.find_or_create_from_auth_hash(provider, payload)
    auth = AuthIdentity.where(provider: provider, login: auth_identity_params(payload)[:login]).first

    if auth.present?
      return auth.user
    else
      user = create(user_params(payload))
      user.create_auth_identity(auth_identity_params(payload))
    end
  end

  def self.update_by_public_id(public_id:, full_name:, position:)
    user = User.find_by_public_id!(public_id)
    user.update(full_name: full_name, position: position)
  end

  def self.update_by_public_id(public_id:, role:)
    user = User.find_by_public_id!(public_id)
    user.update(role: role)
  end

  def self.which_to_assign
    User.where(role: 'employee').order(Arel.sql('RANDOM()')).first
  end

  def manager_access?
    role == 'manager' || role == 'admin'
  end

  private

  def user_params(payload)
    {
      public_id: payload['info']['public_id'],
      full_name: payload['info']['full_name'],
      email: payload['info']['email'],
      role: payload['info']['role'],
    }
  end

  def auth_identity_params(payload)
    {
      uid: payload['uid'],
      token: payload['credentials']['token'],
      login: payload['info']['email']
    }
  end
end