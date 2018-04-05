FactoryBot.define do
  factory :role do
    name 'Super Admin'
  end

  factory :view_only, class: Role do
    name 'View Only'

    after(:create) do |role, evaluator|
      role.privileges.create!([
        { action: 'read', weight: 1, resource: '/home' },
        { action: 'read', weight: 1, resource: '/devices' },
        { action: 'read', weight: -1, resource: '/devices/download' },
        { action: 'read', weight: -1, resource: '/devices/{id}' },
      ])
    end
  end

   factory :user2, class: Role do
    name 'User'

    after(:create) do |role, evaluator|
      role.privileges.create!([
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
    end
  end

  factory :super_user, class: Role do
    name 'Super User'

    after(:create) do |role, evaluator|
      role.privileges.create!([
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
        { action: 'read', weight: 1, resource: '/presets' },
        { action: 'update', weight: 1, resource: '/presets' },
        { action: 'create', weight: 1, resource: '/presets' },
        { action: 'delete', weight: 1, resource: '/presets' },
        { action: 'read', weight: 1, resource: '/objects' },
        { action: 'update', weight: 1, resource: '/objects' },
        { action: 'create', weight: 1, resource: '/objects' },
        { action: 'delete', weight: 1, resource: '/objects' },
        { action: 'read', weight: 1, resource: '/provisions' },
        { action: 'update', weight: 1, resource: '/provisions' },
        { action: 'create', weight: 1, resource: '/provisions' },
        { action: 'delete', weight: 1, resource: '/provisions' },
        { action: 'read', weight: 1, resource: '/faults' },
        { action: 'update', weight: 1, resource: '/faults' },
        { action: 'create', weight: 1, resource: '/faults' },
        { action: 'delete', weight: 1, resource: '/faults' },
        { action: 'read', weight: 1, resource: '/roles' },
        { action: 'read', weight: 1, resource: '/logs' },
      ])
    end
  end

  factory :admin, class: Role do
    name 'Admin'

    after(:create) do |role, evaluator|
      role.privileges.create!([
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
        { action: 'read', weight: 1, resource: '/presets' },
        { action: 'update', weight: 1, resource: '/presets' },
        { action: 'create', weight: 1, resource: '/presets' },
        { action: 'delete', weight: 1, resource: '/presets' },
        { action: 'read', weight: 1, resource: '/objects' },
        { action: 'update', weight: 1, resource: '/objects' },
        { action: 'create', weight: 1, resource: '/objects' },
        { action: 'delete', weight: 1, resource: '/objects' },
        { action: 'read', weight: 1, resource: '/provisions' },
        { action: 'update', weight: 1, resource: '/provisions' },
        { action: 'create', weight: 1, resource: '/provisions' },
        { action: 'delete', weight: 1, resource: '/provisions' },
        { action: 'read', weight: 1, resource: '/faults' },
        { action: 'update', weight: 1, resource: '/faults' },
        { action: 'create', weight: 1, resource: '/faults' },
        { action: 'delete', weight: 1, resource: '/faults' },
      ])
    end
  end

  factory :super_admin, class: Role do
    name 'Super Admin'

    after(:create) do |role, evaluator|
      role.privileges.create!([
        { action: 'read', weight: 1, resource: '/' },
        { action: 'create', weight: 1, resource: '/' },
        { action: 'update', weight: 1, resource: '/' },
        { action: 'delete', weight: 1, resource: '/' }
      ])
    end
  end
end
