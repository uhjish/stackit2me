require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'loj2kbTrHJW0MLyevIMF5tfKf'
  config.consumer_secret = 'KjjTaDCBfKhx9d3eZZUnrS6AQ9VfKH2glabf1Xt0EaeOU3M9h4'
  config.access_token = '2908219731-RhilzscuouXWRBFKWUlDmwc3qx3eJJKPcwwk1RO'
  config.access_token_secret = 'CU75quJrFOxMdhwr9LHBRLIMr74A90TR0lMingSaGPY8V'
end

search_term = URI::encode('#todayilearned')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
