class LDAPUser < User
  devise :ldap_authenticatable, :rememberable, :trackable, :validatable
end
