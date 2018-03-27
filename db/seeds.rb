# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create(id: 1, name: 'View Only')
Role.create(id: 2, name: 'User')
Role.create(id: 3, name: 'Super User')
Role.create(id: 4, name: 'Admin')
Role.create(id: 5, name: 'Super Admin')

# View
Privilege.create(action: 'read', weight: 1, resource: '/', role_id: 1)

# Admin
Privilege.create(action: 'read', weight: 1, resource: '/', role_id: 4)
Privilege.create(action: 'read', weight: -1, resource: '/users', role_id: 4)
Privilege.create(action: 'read', weight: -1, resource: '/roles', role_id: 4)

# Super Admin
Privilege.create(action: 'read', weight: 1, resource: '/', role_id: 5)
Privilege.create(action: 'create', weight: 1, resource: '/', role_id: 5)
Privilege.create(action: 'update', weight: 1, resource: '/', role_id: 5)
Privilege.create(action: 'delete', weight: 1, resource: '/', role_id: 5)


if Rails.env.development?
  User.create(id: 1, username: 'view_only', password: 'password')
  User.create(id: 2, username: 'user', password: 'password')
  User.create(id: 3, username: 'super_user', password: 'password')
  User.create(id: 4, username: 'admin', password: 'password')
  User.create(id: 5, username: 'super_admin', password: 'password')

  UserRole.create(user_id: 1, role_id: 1)
  UserRole.create(user_id: 4, role_id: 4)
  UserRole.create(user_id: 5, role_id: 5)
end