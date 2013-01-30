class DirectoryUser < User
  devise :ldap_authenticatable, :rememberable, :trackable
end
