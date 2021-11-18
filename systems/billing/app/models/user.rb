class User < ApplicationRecord
  has_many :auth_identities, dependent: :delete_all

  def self.find_or_create_from_auth_hash(provider, payload)
    auth = AuthIdentity.where(provider: provider, login: auth_identity_params(payload)[:login]).first

    return auth.user if auth.present?

    user = User.where(email: auth_identity_params(payload)[:login]).first
    user = create(user_params(payload)) if user.blank?
    user.auth_identities.create(auth_identity_params(payload).merge(provider: provider))

    user
  end

  def self.update_data_by_public_id(public_id:, full_name:, position:)
    user = User.find_by_public_id(public_id)
    user.update(full_name: full_name, position: position) if user
  end

  def self.update_role_by_public_id(public_id:, role:)
    user = User.find_by_public_id(public_id)
    user.update(role: role) if user
  end

  def self.which_to_assign_id
    User.where(role: 'employee').order(Arel.sql('RANDOM()')).limit(1).pluck(:id).first
  end

  def manager_access?
    role == 'manager' || role == 'admin'
  end

  def self.auth_identity_params(payload)
    {
      uid: payload['uid'],
      token: payload['credentials']['token'],
      login: payload['info']['email']
    }
  end

  def self.user_params(payload)
    {
      public_id: payload['info']['public_id'],
      full_name: payload['info']['full_name'],
      email: payload['info']['email'],
      role: payload['info']['role'],
    }
  end
end