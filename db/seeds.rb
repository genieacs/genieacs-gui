# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# rails db:seed delete_all=true
if ENV['delete_all'].present?
  Privilege.delete_all
  UserRole.delete_all
  Role.delete_all
  User.delete_all
  Office.delete_all
  City.delete_all
  SectorCity.delete_all
  Division.delete_all
  Department.delete_all
end

Department.create!(code: 'dm301', name: "ภูมิภาค")
Department.create!(code: 'dm302', name: "นครหลวง")

view_only = Role.create(id: 1, name: 'View Only')
user = Role.create(id: 2, name: 'User')
super_user = Role.create(id: 3, name: 'Super User')
admin = Role.create(id: 4, name: 'Admin')
super_admin = Role.create(id: 5, name: 'Super Admin')

# View
view_only.privileges.create!([
  { action: 'read', weight: 1, resource: '/home' },
  { action: 'read', weight: 1, resource: '/devices' },
  { action: 'read', weight: -1, resource: '/devices/download' },
  { action: 'read', weight: -1, resource: '/devices/{id}' },
])

# User
user.privileges.create!([
  { action: 'read', weight: 1, resource: '/home' },
  { action: 'read', weight: 1, resource: '/devices' },
  { action: 'create', weight: 1, resource: '/devices/tags' },
  { action: 'delete', weight: 1, resource: '/devices/tags' },
  { action: 'update', weight: 1, resource: '/devices/reboot' },
  { action: 'update', weight: 1, resource: '/devices/factory_reset' },
  { action: 'update', weight: 1, resource: '/devices/download' },
  { action: 'read', weight: 1, resource: '/faults' },
  { action: 'read', weight: 1, resource: '/tasks' },
  { action: 'update', weight: 1, resource: '/tasks/retry' },
  { action: 'delete', weight: 1, resource: '/tasks' },
  { action: 'update', weight: 1, resource: '/faults' },
  { action: 'create', weight: 1, resource: '/faults' },
  { action: 'delete', weight: 1, resource: '/faults' },
  { action: 'read', weight: 1, resource: '/provisions' },
  { action: 'update', weight: 1, resource: '/provisions' },
  { action: 'create', weight: 1, resource: '/provisions' },
  { action: 'delete', weight: 1, resource: '/provisions' },
])

# Super User
super_user.privileges.create!([
  { action: 'read', weight: 1, resource: '/home' },
  { action: 'read', weight: 1, resource: '/devices' },
  { action: 'create', weight: 1, resource: '/devices/tags' },
  { action: 'delete', weight: 1, resource: '/devices/tags' },
  { action: 'update', weight: 1, resource: '/devices/reboot' },
  { action: 'update', weight: 1, resource: '/devices/factory_reset' },
  { action: 'update', weight: 1, resource: '/devices/download' },
  { action: 'delete', weight: 1, resource: '/devices' },
  { action: 'read', weight: 1, resource: '/tasks' },
  { action: 'update', weight: 1, resource: '/tasks/retry' },
  { action: 'delete', weight: 1, resource: '/tasks' },
  { action: 'read', weight: 1, resource: '/users' },
  { action: 'update', weight: 1, resource: '/users' },
  { action: 'create', weight: 1, resource: '/users' },
  { action: 'delete', weight: 1, resource: '/users' },
  { action: 'read', weight: 1, resource: '/provisions' },
  { action: 'update', weight: 1, resource: '/provisions' },
  { action: 'create', weight: 1, resource: '/provisions' },
  { action: 'delete', weight: 1, resource: '/provisions' },
  { action: 'read', weight: 1, resource: '/faults' },
  { action: 'update', weight: 1, resource: '/faults' },
  { action: 'create', weight: 1, resource: '/faults' },
  { action: 'delete', weight: 1, resource: '/faults' },
  { action: 'read', weight: 1, resource: '/roles' },
  { action: 'update', weight: 1, resource: '/roles' },
  { action: 'create', weight: 1, resource: '/roles' },
  { action: 'delete', weight: 1, resource: '/roles' },
  { action: 'read', weight: 1, resource: '/logs' },
])

# Admin
admin.privileges.create!([
  { action: 'read', weight: 1, resource: '/home' },
  { action: 'read', weight: 1, resource: '/devices' },
  { action: 'create', weight: 1, resource: '/devices/tags' },
  { action: 'delete', weight: 1, resource: '/devices/tags' },
  { action: 'update', weight: 1, resource: '/devices/reboot' },
  { action: 'update', weight: 1, resource: '/devices/factory_reset' },
  { action: 'update', weight: 1, resource: '/devices/download' },
  { action: 'delete', weight: 1, resource: '/devices' },
  { action: 'read', weight: 1, resource: '/tasks' },
  { action: 'update', weight: 1, resource: '/tasks/retry' },
  { action: 'delete', weight: 1, resource: '/tasks' },
  { action: 'read', weight: 1, resource: '/users' },
  { action: 'update', weight: 1, resource: '/users' },
  { action: 'create', weight: 1, resource: '/users' },
  { action: 'delete', weight: 1, resource: '/users' },
  { action: 'read', weight: 1, resource: '/provisions' },
  { action: 'update', weight: 1, resource: '/provisions' },
  { action: 'create', weight: 1, resource: '/provisions' },
  { action: 'delete', weight: 1, resource: '/provisions' },
  { action: 'read', weight: 1, resource: '/faults' },
  { action: 'update', weight: 1, resource: '/faults' },
  { action: 'create', weight: 1, resource: '/faults' },
  { action: 'delete', weight: 1, resource: '/faults' },
])

# Super Admin
super_admin.privileges.create!([
  { action: 'read', weight: 1, resource: '/' },
  { action: 'create', weight: 1, resource: '/' },
  { action: 'update', weight: 1, resource: '/' },
  { action: 'delete', weight: 1, resource: '/' }
])

if Rails.env.development?
  User.create(id: 1, username: 'view_only', password: 'password')
  User.create(id: 2, username: 'user', password: 'password')
  User.create(id: 3, username: 'super_user', password: 'password')
  User.create(id: 4, username: 'admin', password: 'password')
  User.create(id: 5, username: 'super_admin', password: 'password')

  UserRole.create(user_id: 1, role_id: 1)
  UserRole.create(user_id: 2, role_id: 2)
  UserRole.create(user_id: 3, role_id: 3)
  UserRole.create(user_id: 4, role_id: 4)
  UserRole.create(user_id: 5, role_id: 5)
end

PaperTrail::Version.delete_all

# Reset id sequence on each tables
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end