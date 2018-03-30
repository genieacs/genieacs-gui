require 'rails_helper'

RSpec.describe "task delete_log" do
  let(:today) { Time.zone.now }

  before do
    Rake.application.rake_require 'tasks/delete_log'
    Rake::Task.define_task(:environment)
  end

  describe 'run task delete:log_activity' do
    it "should delete all" do
      PaperTrail::Version.create!(event: 'create', item_type: 'User', item_id: 1, created_at: today - 91.day)
      PaperTrail::Version.create!(event: 'create', item_type: 'User', item_id: 1, created_at: today - 100.day)

      Rake::Task['delete:log_activity'].execute
      expect(PaperTrail::Version.count).to eq(0)
    end

    it "should delete 3 record" do

      3.times.each do |i|
        PaperTrail::Version.create!(event: 'create', item_type: 'User', item_id: 1, created_at: today - 91.day)
      end

      PaperTrail::Version.create!(event: 'create', item_type: 'User', item_id: 1, created_at: today - 90.day)
      PaperTrail::Version.create!(event: 'create', item_type: 'User', item_id: 1, created_at: today - 89.day)

      Rake::Task['delete:log_activity'].execute
      expect(PaperTrail::Version.count).to eq(2)
    end

    it "shouldn't delete" do
      3.times.each do |i|
        PaperTrail::Version.create!(event: 'create', item_type: 'User', item_id: 1, created_at: today - 89.day)
      end
      PaperTrail::Version.create!(event: 'create', item_type: 'User', item_id: 1, created_at: today - 90.day)

      Rake::Task['delete:log_activity'].execute
      expect(PaperTrail::Version.count).to eq(4)
    end
  end
end
