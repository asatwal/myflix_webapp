class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string  :email_address
      t.string  :full_name
      t.text    :message
      t.integer :inviter_id
      t.timestamps
    end
  end
end
