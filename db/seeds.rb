# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create(name: 'anonymous')
Role.create(name: 'admin')
Role.create(name: 'view')

Privilege.create(action: 'read', weight: 1, resource: '/home', role_id: 1)

Privilege.create(action: 'read', weight: 1, resource: '/', role_id: 2)
Privilege.create(action: 'create', weight: 1, resource: '/', role_id: 2)
Privilege.create(action: 'update', weight: 1, resource: '/', role_id: 2)
Privilege.create(action: 'delete', weight: 1, resource: '/', role_id: 2)

Privilege.create(action: 'read', weight: 1, resource: '/', role_id: 3)
Privilege.create(action: 'read', weight: -1, resource: '/users', role_id: 3)
Privilege.create(action: 'read', weight: -1, resource: '/roles', role_id: 3)

User.create(username: 'admin', password: 'admin')
User.create(username: 'user', password: 'user')

UserRole.create(user_id: 1, role_id: 2)
UserRole.create(user_id: 2, role_id: 3)
