class CreateDefaultUser < ActiveRecord::Migration[8.0]
  def up
    User.create!(
      email_address: "default@example.org",
      password: "123456",
      password_confirmation: "123456"
    )
  end

  def down
    User.find_by(email_address: "default@example.org")&.destroy
  end
end
