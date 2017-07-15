require "open-uri"
require "nokogiri"
module AtcoderScrayper
  module_function

  def get_rate_rank users
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

  def get_contest_rank contest_name, users
    url = "http://#{contest_name}.contest.atcoder.jp/standings"
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    list = doc.xpath('//script[@type="text/JavaScript"]')
    .children[0]
    .to_s.match(/data: \[.+\]/)
    .to_s.scan(/\{.+?\}/)
    .map{|data| data.to_s.delete("{").delete("}").split(",") }
    .inject([]){|list,data| list << data unless data[0].match("\"task_id\""); list }

    data = []
    list.each do |d|
      d.map!{|dd| dd.delete("\"") }
      name = d[3].split(":")[1].delete("\"")
      data << (d[0]+"\n"+d[3]) if users.include?(name)
    end
    return data.join("\n\n")
  end
end
