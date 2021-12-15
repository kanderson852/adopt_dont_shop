class AddApprovalStatusToPetApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :pet_applications, :approval_status, :string
  end
end
