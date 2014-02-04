# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

desc 'stop rails'
task :stop do

  pid_file = 'tmp/pids/server.pid'
  if File.exist?(pid_file)
    pid = File.read(pid_file).to_i
    puts "Killing Server: #{pid.to_s}"
    Process.kill 9, pid
    File.delete pid_file
    puts "Deleted: #{pid_file}"
  else
    puts "Cannot seem to find a rails process"
  end
  system "rake jobs:clear"
end

desc 'start rails'
task :start do
  raise "Supply all ENV params: gmail, etc" if ENV["GMAIL_USERNAME"]
  .nil? || ENV["GMAIL_PASSWORD"].nil?

  system "GMAIL_USERNAME=#{ENV["GMAIL_USERNAME"]} GMAIL_PASSWORD=#{ENV["GMAIL_PASSWORD"]} rake jobs:work &"
  system "rails s"
end

Learnster::Application.load_tasks
