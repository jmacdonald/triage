ActiveAdmin.register System do
  filter :name

  index do
    column :name
    default_actions
  end
end
