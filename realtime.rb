$LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'slack-ruby-client'
require 'atcoder'
include AtcoderScrayper
TOKEN = ENV['SLACK']
Slack.configure do |conf|
  conf.token = TOKEN
end

client = Slack::RealTime::Client.new

client.on :message do |data|
  query = data.text.split(":")
  case query[0]
  when 'rank'
    contest_name = query[1]
    comment =  "FF外から失礼するゾ〜\nAtcoder面白スギィ！\n自分、#{contest_name}のランキングいいっすか？\n"
    client.message channel: data.channel, text: comment, as_user: true
    text = get_contest_rank(contest_name, ["hayabusa104", "yamad","zura", "kshinya", "tossy", "imulan"])
    if text.present?
      client.message channel: data.channel, text: text, as_user: true
    else
      client.message channel: data.channel, text: "誰も参加してないよー\n", as_user: true
    end
  end
end

client.start!
