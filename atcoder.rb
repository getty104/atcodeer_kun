require "open-uri"
require "nokogiri"
module AtcoderScrayper
  module_function
  def search users
    list = []
    79.times do |i|
      url = "https://atcoder.jp/ranking?p=#{i+1}"
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      # htmlをパース(解析)してオブジェクトを生成
      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.xpath('//tbody//tr').each do |node|
        #list << node.css('a').inner_text + ","+ node.css("td").inner_text
        data = node.inner_html.gsub("</td>","<td>").split("<td>")
        name = node.css("a").inner_text
        text = <<~EOS
        #{name}:
            rank: #{data[1]}
            rate: #{data[5]}
        EOS
        list << text if users.include?(name)
      end
    end
    return list.join("\n")
  end
end
