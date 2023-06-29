require 'time'
require 'date'

class TaskTimer

  #accesor for parameters:
  attr_accessor :task_name, :task_start, :task_end, :minutes

  #parametric constructor:
  def initialize(task_name = nil, task_start = nil, task_end = nil)
    if[task_name, task_start, task_end].any?(&:nil?)
      puts "Please fill in all task parameters"
    end
	  @task_name, @task_start, @task_end = task_name, task_start, task_end
  end

  # Class methods start here:
  class << self

    def all_durations_list(tasks)
      durations = []
      tasks.each { |task| durations.push(task.duration) }
      return durations
    end

    def filtered_tasks_list(tasks, func)
      filtered_tasks = []
      tasks.each do |task|
        if task.duration == all_durations_list(tasks).method(func).call
          filtered_tasks.push(task)
        end
      end
      filtered_tasks
    end

    def put_tasks_list(list)
      schedules_list = Array.new
      list.each do |task|
        temp_obj = TaskTimer.new(task.task_name, task.task_start, task.task_end)
        schedules_list.push(
          #start date:
          "#{temp_obj.string_to_date_time(temp_obj.task_start).strftime("%Y-%m-%d")}," + " " +
          #start weekday:
          "#{temp_obj.string_to_date_time(temp_obj.task_start).strftime("%A")}," + " " +
          #task name:
          "#{temp_obj.task_name}," + " " +
          #start time:
          "#{temp_obj.string_to_date_time(temp_obj.task_start).strftime("%H:%M")}," + " " +
          #end time:
          "#{temp_obj.string_to_date_time(temp_obj.task_end).strftime("%H:%M")}," + " " +
          #duration:
          "#{temp_obj.duration}"
        )
      end
      puts schedules_list
    end

    def split_overnight_tasks(task_timers)
      task_timers.compact.map do |task|
        task_days = (Date.parse(task.task_end) - Date.parse(task.task_start)).to_i
        if task_days > 0
          task_index = task_timers.find_index(task)
          for i in 1..task_days - 1
            task_timers.insert(task_index + 1, TaskTimer.new(task.task_name, "#{(Date.parse(task.task_start) + (task_days - 1)).strftime("%Y-%m-%d")} 00:00", "#{(Date.parse(task.task_start) + (task_days - 1)).strftime("%Y-%m-%d")} 23:59"))
            task_index = task_index + 1
          end
          task_timers.insert(task_index + task_days, TaskTimer.new(task.task_name, "#{(Date.parse(task.task_start) + task_days).strftime("%Y-%m-%d")} 00:00", task.task_end) )
          task_index = task_index + 1
          task.task_end = "#{Date.parse(task.task_start).strftime("%Y-%m-%d")} 23:59"
        end
      end
      task_timers
    end

    def list_schedule(task_timers)
      tasks_sorted_by_start_desc = split_overnight_tasks(task_timers).compact
      .sort_by { |timer| timer.string_to_date_time(timer.task_start) }.reverse
      put_tasks_list(tasks_sorted_by_start_desc)
    end

    def max_task(task_timers)
      put_tasks_list(filtered_tasks_list(task_timers, :max))
    end

    def min_task(task_timers)
      put_tasks_list(filtered_tasks_list(task_timers, :min))
    end

    def avg_task(task_timers)
      sum_duration = 0
      all_durations_list(task_timers).each { |duration| sum_duration += duration }
      puts sum_duration / all_durations_list(task_timers).length().to_f
    end

  end
  # Class methods end here

  #Instance methods start here:

  #parser String to DateTime:
  def string_to_date_time (task_event)
     Time.strptime(task_event, "%Y-%m-%d %H:%M")
  end

  #validator:
  def valid?
    task_name != nil &&
    ( string_to_date_time(@task_end) - string_to_date_time(@task_start) ) >= 60.0; #in seconds, float
  end

  #calculator for task duration in minutes:
  def duration
    if valid?
      return task_duration = ( (string_to_date_time(@task_end) - string_to_date_time(@task_start) ) / 60 )
        .to_i
        #.to_s.delete_suffix(".0")
      end
    end

  #adds minutes to @task_end:
  def add_time(minutes)
    task_end_in_date_time = string_to_date_time(@task_end)
    new_task_end_string = (task_end_in_date_time + minutes * 60).to_s.delete_suffix(':00 +0300')
    @task_end = new_task_end_string
  end

end

TaskTimer.list_schedule([
  TaskTimer.new("Prepare breakfast", "2023-06-05 12:35", "2023-06-05 12:36"),
  TaskTimer.new("Prepare dinner", "2024-06-05 12:35", "2024-06-05 12:39"),
  TaskTimer.new("Prepare brunch", "2022-06-05 12:35", "2022-06-07 12:39"),
  TaskTimer.new("Dance", "2020-06-03 12:35", "2020-06-05 12:39"),
  TaskTimer.new("Training", "2022-06-04 12:30", "2022-06-05 12:32")
  ])

#  TaskTimer.max_task([
  #  TaskTimer.new("Prepare lunch", "2022-06-05 12:35", "2022-06-05 12:39"),
  #  TaskTimer.new("Prepare breakfast", "2023-06-05 12:35", "2023-06-05 12:36"),
    #TaskTimer.new("Prepare breakfast", "2023-06-05 12:36", "2023-06-05 12:36"),
  #  TaskTimer.new("Prepare agenda", "2024-06-05 12:35", "2024-06-05 12:39"),
  #  TaskTimer.new("Prepare lunch", "2023-06-05 12:35", "2023-06-07 12:39")
  #  ])

  #TaskTimer.min_task([
  #  TaskTimer.new("Prepare lunch", "2022-06-05 12:35", "2024-06-05 12:39"),
    #TaskTimer.new("Prepare breakfast", "2023-06-05 12:35", "2023-06-05 12:36"),
    #TaskTimer.new("Prepare breakfast", "2023-06-05 12:36", "2023-06-05 12:36"),
  #  TaskTimer.new("Prepare agenda", "2024-06-05 12:35", "2024-06-05 12:39"),
  #  TaskTimer.new("Prepare lunch", "2023-06-05 12:35", "2023-06-07 12:39")
    #])

    #TaskTimer.avg_task([
      #TaskTimer.new("Prepare lunch", "2022-06-05 12:35", "2024-06-05 12:39"),
    #  TaskTimer.new("Prepare breakfast", "2023-06-05 12:35", "2023-06-05 12:36"),
      #TaskTimer.new("Prepare breakfast", "2023-06-05 12:36", "2023-06-05 12:36"),
    #  TaskTimer.new("Prepare agenda", "2024-06-05 12:35", "2024-06-05 12:39"),
    #  TaskTimer.new("Prepare lunch", "2023-06-05 12:35", "2023-06-07 12:39")
    #  ])

      #TaskTimer.split_overnight_tasks([
      #  TaskTimer.new("sss", "2024-06-05 12:35", "2024-06-05 12:39"),
      #  TaskTimer.new("Prepare lunch", "2023-06-05 12:35", "2023-06-07 12:39"),
      #  TaskTimer.new("eee", "2022-06-05 12:35", "2022-06-05 12:39")
      #  ])
