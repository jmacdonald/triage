admin = User.new({
  email: 'admin@example.com',
  username: 'administrator',
  password: 'administrator',
  password_confirmation: 'administrator',
  name: 'Administrator'
})
admin.role = 'administrator'
admin.save

Status.create([{title: 'New', default: true}, {title: 'Assigned'}, {title: 'Closed', closed: true}])