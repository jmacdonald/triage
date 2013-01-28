ActiveAdmin.register Status do
  filter :title

  index do
    column :title
    column :default
    column :closed
    default_actions
  end
end
