module ApplicationHelper
  def task_fault(task)
    begin
      task['fault']['detail']['Fault']['FaultString']
    rescue
      task['fault']
    end
  end
end
