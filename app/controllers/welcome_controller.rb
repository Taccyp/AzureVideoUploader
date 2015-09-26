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
      job = AzureMediaService::Job.get(a.job_id)
      puts "job get"
    else
      puts 'encoding'
        if job.State = '3'
          puts job
          puts "job state finished"
          asset = job.output_assets()[0]
          puts "!!!!!!!!!!!!!!!!!"

          puts "PUBLISHING"
          policy = AzureMediaService::AccessPolicy.create(name: asset.Name,duration_minutes: 300, permission: 1)
          locator = AzureMediaService::Locator.create(policy_id: policy.Id, asset_id: asset.Id, type: 1)
          puts asset.files
          puts "ASSETTTTTT"
          puts asset
          puts "PUBLISH COMPLETE"


          puts locator
          puts "asset files______"
          asset.files
          pub_url = asset.Uri+"/"+asset.files[0].Name+locator.ContentAccessComponent
          vid = Video.new
          vid.low_res_url = pub_url
          vid.save
          
          puts "ENCODING"
          job = asset.encode_job('H264 Adaptive Bitrate MP4 Set SD 4x3 for iOS Cellular Only')
          vid.job_id = job.__metadata["id"]
          puts job.uri
          puts "!!!!!!!!!!!!!"
          puts vid.job_id
          vid.save
          puts "ENCODING COMPLETE"
          puts job
      else
        puts "job not finished"
      end
    end
  end
  

  @tags = Tag.all
end

end