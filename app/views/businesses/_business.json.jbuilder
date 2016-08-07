json.extract! business, :id, :uuid, :name, :address, :address2, :city, :state, :zip, :country, :phone, :website, :created_at, :updated_at
json.url business_url(business, format: :json)