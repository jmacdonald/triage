ActiveAdmin.register User do
  form do |f|
    f.inputs "Details" do
      f.input :username
      f.input :email
      f.input :name
      f.input :password
      f.input :role, as: :select, collection: User::ROLE_OPTIONS
      f.input :available
    end
    f.buttons
  end  
end
