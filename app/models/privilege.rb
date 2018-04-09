class Privilege < ApplicationRecord
  has_paper_trail

  ACTION_COLLECTION = [
    ['Read', 'read'], ['Create', 'create'], ['Update', 'update'], ['Delete', 'delete']
  ]
  WEIGHT_COLLECTION = [['Allow', 1], ['Deny', -1]]
  RESOURCE_COLLECTION = [
    ['/', '/'],
    ['/home', '/home'],
    ['/devices', '/devices'],
    ['/devices/show', '/devices/{id}'],
    ['/devices/tags', '/devices/tags'],
    ['/devices/tasks', '/tasks'],
    ['/devices/tasks/retry', '/tasks/retry'],
    ['/devices/reboot', '/devices/reboot'],
    ['/devices/factory_reset', '/devices/factory_reset'],
    ['/devices/push_file', '/devices/download'],
    ['/devices/add_firmware', '/devices/files'],
    ['/faults', '/faults'],
    ['/presets', '/presets'],
    ['/objects', '/objects'],
    ['/provisions', '/provisions'],
    ['/virtaul_parameters', '/virtaul_parameters'],
    ['/files', '/files'],
    ['/cpe_configs', '/cpe_configs'],
    ['/activity_logs', '/logs'],
    ['/device_lists', '/device_lists'],
    ['/offices', '/offices'],
    ['/users', '/users'],
    ['/roles', '/roles']
  ]

  belongs_to :role
  validates :action, presence: true,
                    length: { minimum: 4 }
  validates :weight, presence: true,
                    length: { minimum: 1 }
  validates :resource, presence: true,
                    length: { minimum: 1 }

end
