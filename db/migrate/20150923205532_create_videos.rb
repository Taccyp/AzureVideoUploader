class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url
      t.string :job_id
      t.string :low_res_url

      t.timestamps null: false
    end
  end
end
