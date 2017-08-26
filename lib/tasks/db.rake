namespace :db do
  desc "Extends db tasks"
  task fetch: :environment do
    sh "ssh chappy@chappy.world 'pg_dump -U chappy hustle_production' \ >> ./db/database.bak"
  end

  task replace: :environment do
    sh "dropdb hustle_dev && createdb hustle_dev && psql hustle_dev < ./db/database.bak"
  end

  task pull: :environment do
    Rake::Task["db:fetch"].invoke
    Rake::Task["db:replace"].invoke
  end
end