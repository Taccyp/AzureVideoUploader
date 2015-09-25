class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token

def index

  puts "LOADIG VIDS"
  @videos = Video.all

  @videos.each do |a|
    if a.low_res_url.nil?
      puts "getting job"
      puts a.job_id
      puts "^^^^^^^^^^"
      job = AzureMediaService::Job.get(job_id: a.job_id)
        if job.State = '3'
          puts "job state finished"
          puts AzureMediaService::Job.out_assets(job.OutputMediaAssets)
      else
        puts "job not finished"
      end
    end
  end
  

  @tags = Tag.all
end

end