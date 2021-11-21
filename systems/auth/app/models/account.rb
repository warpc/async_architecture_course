require 'water_drop_producer'

class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
  }

  after_commit do
    account = self

    # ----------------------------- produce event -----------------------
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'auth_service',
      event_name: 'Account.Created',
      data: {
        public_id: account.public_id,
        email: account.email,
        full_name: account.full_name,
        position: account.position
      }
    }

    WaterDropProducer.sync_call(event.to_json, topic: 'accounts_stream')
    # --------------------------------------------------------------------
  end
end
