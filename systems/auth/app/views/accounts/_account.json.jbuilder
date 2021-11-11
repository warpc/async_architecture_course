json.extract! account, :id, :created_at, :updated_at
json.email_address account.email
json.url account_url(account, format: :json)
