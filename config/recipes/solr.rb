namespace :solr do
  
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end

  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    if not capture("#{shared_path}/pids/sunspot-solr*").include? "No such file"
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
    else
      run "echo 'Cannot stop Solr as no PIDs exist'"
    end
  end

  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data"
    start
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end

  desc "stop solr, remove data, start solr, reindex all records"
  task :hard_reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data/*"
    start
    reindex
  end
 
  desc "simple reindex" #note the yes | reindex to avoid the nil.chomp error
  task :reindex, roles: :app do
    run "cd #{current_path} && yes | RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end

end

before 'deploy:restart', 'solr:stop'
after 'deploy:restart', 'solr:start'
after 'deploy:setup', 'deploy:setup_solr_data_dir'