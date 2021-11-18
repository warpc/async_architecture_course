json.extract! account, :pubic_id, :created_at, :updated_at, :role, :full_name, :position, :email
json.url account_url(account, format: :json)
