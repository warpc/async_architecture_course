require 'water_drop_producer'

class Account < ApplicationRecord
  #before_create :attach_uuid

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
    # This is workaround, because public is not setup correctly in after_commit callback
    # https://github.com/rails/rails/issues/43279
    account = self.reload
    # ----------------------------- produce event -----------------------
    event = {
      event_version: 1,
      event_name: 'Account.Created',
      data: {
        public_id: account.public_id,
        email: account.email,
        full_name: account.full_name,
        position: account.position
      }
    }

    Producer.call(event: event, topic: 'account_streams')
    # --------------------------------------------------------------------
  end

  def attach_uuid
    self.public_id = SecureRandom.uuid
  end
end
