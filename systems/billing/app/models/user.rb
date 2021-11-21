class User < ApplicationRecord
  has_many :auth_identities, dependent: :delete_all
  has_many :transactions
  has_many :payments

  def self.find_or_create_from_auth_hash(provider, payload)
    auth = AuthIdentity.where(provider: provider, login: auth_identity_params(payload)[:login]).first

    return auth.user if auth.present?

    user = User.where(email: auth_identity_params(payload)[:login]).first
    user = create(user_params(payload)) if user.blank?
    user.auth_identities.create(auth_identity_params(payload).merge(provider: provider))

    user
  end

  def self.create_or_update_by_public_id(public_id:, params: {})
    user = create_or_find_by!(public_id: public_id)
    user.with_lock { user.update!(**params) } if data.present?

    user
  end

  def self.update_data_by_public_id(public_id:, full_name:, email:)
    user = User.find_by_public_id(public_id)
    user.with_lock { user.update(full_name: full_name, email: email) } if user
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