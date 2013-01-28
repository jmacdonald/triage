ActiveAdmin.register System do
  filter :name

  index do
    column :name
    default_actions
  end

  form do |f|
    f.inputs "System" do
      f.input :name
    end

    f.inputs "Responsible Users" do
      f.input :users
    end
    f.buttons
  end
end
