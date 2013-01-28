ActiveAdmin.register User do
  filter :username
  filter :role

  index do
    column :username
    column :name
    column :role
    column :available
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :username
      f.input :email
      f.input :name
      f.input :password
      f.input :role, as: :select, collection: User::ROLE_OPTIONS
      f.input :available
    end

    f.inputs "Responsibilities" do
      f.input :systems
    end
    f.buttons
  end  
end
