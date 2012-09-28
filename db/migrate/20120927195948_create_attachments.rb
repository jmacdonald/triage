class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :request

      t.timestamps
    end
    add_index :attachments, :request_id
  end
end
