task :birthday => :environment do
  @user=User.where("strftime('%m%d', birthday) = ? ", (Date.today).strftime('%m%d'))
  # d="Happy birthday  #{@user.take.firstname}"
  if @user.exists?
     @news=News.create(description: "Happy birthday  #{@user.take.email}",name:"Congratulation!",news_date:@user.take.birthday)
  else
    puts "no"
  end
end
task :release => :environment do
  @project=Project.where(" release = ? ", Date.today)
  if @project.exists?
    @news=News.create(description: " Project release  #{@project.take.name}",name:"Project release!",news_date:@project.take.release)
  else
    puts "no"
  end
end
task :news => [:birthday,:release]