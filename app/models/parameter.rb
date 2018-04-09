class Parameter < ActiveRecord::Base
  belongs_to :device

  def self.by_date(start_str, end_str)
    start_date = Time.zone.parse(start_str).beginning_of_day
    end_date   = Time.zone.parse(end_str).end_of_day
    where(created_at: start_date..end_date)
  end
end
