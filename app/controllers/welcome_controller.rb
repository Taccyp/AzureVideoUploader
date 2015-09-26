class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token

def index

  puts "LOADIG VIDS"
  @videos = Video.all

  @videos.each do |a|

    if a.low_res_url.nil?
      puts 'KAPPPPPPPAAA!!!!!'
      job = AzureMediaService::Job.get(a.job_id)
        if job.State == '3'
          asset = job.output_assets()[0]
          policy = AzureMediaService::AccessPolicy.create(name: asset.Name,duration_minutes: 300, permission: 1)
          locator = AzureMediaService::Locator.create(policy_id: policy.Id, asset_id: asset.Id, type: 1)
          asset.files
          low_url = asset.Uri+"/"+asset.files[0].Name+locator.ContentAccessComponent
          vid = Video.where(id: a.id)
          vid.low_res_url = low_url
          job = asset.encode_job('H264 Adaptive Bitrate MP4 Set SD 4x3 for iOS Cellular Only')
          vid.job_id = job.__metadata["id"]
          vid.save

      else
        puts "job not finished"
      end
    end
  end
  

  @tags = Tag.all
end

end