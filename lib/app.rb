require 'sinatra'
require 'right_aws'
require 'haml'

class S3Test < Sinatra::Base
  puts 'Setting up access key'
  AWS_ACCESS_KEY = 'AKIAI3HDDHE7NJ2HWRQA'
  puts 'Setting up secret access key'
  AWS_SECRET_ACCESS_KEY = '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'
  puts 'Setting up bucket'
  AWS_BUCKET = 'robbiebobbins'
  puts 'AWS setup complete'

  put '/' do
    puts 'Hit put on root'
    puts 'About to new bucket'
    s3 = RightAws::S3.new(AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY)
    puts 'assigning bobbins bucket'
    bobbins_bucket = s3.bucket(AWS_BUCKET)
    puts 'about to make put request'
    bobbins_bucket.put('S3Test/test.jpg', request.body, 'public-read')
  end

  get '/' do
    puts 'Hit get on root'
    page = "<img src='http://s3.amazonaws.com/robbiebobbins/S3Test/test.jpg'/>"
    haml page
  end

  get '/list' do
    s3 = RightAws::S3.new(AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY)
    bucket_names = s3.buckets.map{|bucket| bucket.name}
    bobbins_bucket = s3.bucket(AWS_BUCKET)
    "Buckets on S3: #{bucket_names.join(', ')} Keys in robbiebobbins #{bobbins_bucket.keys.join(', ')}"
  end
end