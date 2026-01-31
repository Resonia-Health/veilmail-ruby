class CreateAuthTables < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :password_digest, null: false
      t.boolean :email_verified, default: false
      t.boolean :two_factor_enabled, default: false
      t.timestamps
    end

    create_table :verification_tokens do |t|
      t.string :email, null: false, index: true
      t.string :token, null: false, index: { unique: true }
      t.datetime :expires_at, null: false
    end

    create_table :password_reset_tokens do |t|
      t.string :email, null: false, index: true
      t.string :token, null: false, index: { unique: true }
      t.datetime :expires_at, null: false
    end

    create_table :two_factor_tokens do |t|
      t.string :email, null: false, index: true
      t.string :code, null: false
      t.datetime :expires_at, null: false
    end
  end
end
