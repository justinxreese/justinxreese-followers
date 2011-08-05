require "yaml"
require "twitter"
require "git"

key_file = YAML.load_file('config.yml')

Twitter.configure do |config|
  config.consumer_key = key_file['consumer_key']
  config.consumer_secret = key_file['consumer_secret']
  config.oauth_token = key_file['oauth_token']
  config.oauth_token_secret = key_file['oauth_token_secret']
end

follower_file = File.new('followers','w')
followers = Twitter.followers.users.sort{|x,y| x.id <=> y.id}.collect{|x| x.screen_name}
followers.each do |f|
  follower_file.puts f
end

begin
  g = Git.init('.')
  g.add('.')
  g.commit('Followers for '+Time.now.to_s)
  g.push
rescue
  puts 'nothing changed'
end
