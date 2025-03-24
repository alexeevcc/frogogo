class AddSecretIdToCart < ActiveRecord::Migration[8.0]
  def change
    add_column :carts, :secret_id, :string
  end
end
