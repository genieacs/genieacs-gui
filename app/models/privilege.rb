class Privilege < ApplicationRecord
  has_paper_trail

  ACTION_COLLECTION = [
    ['Read', 'read'], ['Create', 'create'], ['Update', 'update'], ['Delete', 'delete']
  ]
  WEIGHT_COLLECTION = [['Allow', 1], ['Deny', -1]]
  RESOURCE_COLLECTION = ['/',
                         '/home',
                         '/devices',
                         '/devices/{id}',
                         '/devices/tags',
                         '/devices/reboot',
                         '/devices/factory_reset',
                         '/devices/download',
                         '/devices/files',
                         '/tasks',
                         '/tasks/retry',
                         '/presets',
                         '/faults',
                         '/objects',
                         '/previsions',
                         '/provisions',
                         '/virtaul_parameters',
                         '/files',
                         '/logs',
                         '/users',
                         '/roles']

  belongs_to :role
  validates :action, presence: true,
                    length: { minimum: 4 }
  validates :weight, presence: true,
                    length: { minimum: 1 }
  validates :resource, presence: true,
                    length: { minimum: 1 }

end
