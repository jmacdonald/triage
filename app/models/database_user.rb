class DatabaseUser < User
  devise :database_authenticatable, :rememberable, :trackable, :validatable
end
