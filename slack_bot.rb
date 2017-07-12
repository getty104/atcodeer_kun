require 'slack-ruby-client'
require './atcoder'
include AtcoderScrayper
# 先ほど取得したTOKENをセット
TOKEN = ENV['SLACK']
Slack.configure do |conf|
  conf.token = TOKEN
end
# RTM Clientのインスタンス生成
client = Slack::Web::Client.new
# slackに接続できたときの処理
  comment = "FF外から失礼するゾ〜\nお前たち、Atcoderやってそうだから、Atcoderランキングを教えといてやるぜぇ！\n"
  text = search(["hayabusa104", "yamad","zura", "kshinya"])
  client.chat_postMessage channel: '#procon', text: comment, as_user: true
  client.chat_postMessage channel: '#procon', text: text, as_user: true