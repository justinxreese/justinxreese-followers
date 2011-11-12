#!/usr/bin/ruby

require "rubygems"
require "yaml"
require "twitter"
require "git"

key_file = YAML.load_file('config.yml')
g = Git.init('.')

Twitter.configure do |config|
  config.consumer_key = key_file['consumer_key']
  config.consumer_secret = key_file['consumer_secret']
  config.oauth_token = key_file['oauth_token']
  config.oauth_token_secret = key_file['oauth_token_secret']
end

follower_file = File.open('followers','w')

cursor = -1 
followers = [] 
begin 
  response = Twitter.followers :cursor => cursor 
  followers += response.users 
  cursor = response.next_cursor 
end while cursor > 0

followers = followers.sort{|x,y| x.id <=> y.id}.collect{|x| x.screen_name}
followers.each do |f|
  follower_file.puts f
end
follower_file.close

g.commit_all('Followers for '+Time.now.to_s)
g.push
