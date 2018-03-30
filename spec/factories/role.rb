FactoryBot.define do
  factory :role do
    name 'Super Admin'
  end

  factory :view_only, class: Role do
    name 'View Only'

    after(:create) do |role, evaluator|
      role.privileges.create!([
        { action: 'read', weight: 1, resource: '/home' },
        { action: 'read', weight: 1, resource: '/devices' }
      ])
    end
  end

   factory :user2, class: Role do
    name 'User'

    after(:create) do |role, evaluator|
      role.privileges.create!([
        { action: 'read', weight: 1, resource: '/home' },
        { action: 'read', weight: 1, resource: '/devices' },
        { action: 'update', weight: 1, resource: '/devices' },
        { action: 'delete', weight: 1, resource: '/devices' },
        { action: 'read', weight: 1, resource: '/faults' },
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
        { action: 'update', weight: 1, resource: '/devices' },
        { action: 'delete', weight: 1, resource: '/devices' },
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
    end
  end

  factory :admin, class: Role do
    name 'Admin'

    after(:create) do |role, evaluator|
      role.privileges.create!([
        { action: 'read', weight: 1, resource: '/home' },
        { action: 'read', weight: 1, resource: '/devices' },
        { action: 'update', weight: 1, resource: '/devices' },
        { action: 'delete', weight: 1, resource: '/devices' },
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
