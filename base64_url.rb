require "base64"

module Base64

  def url_encode64(text)
    return nil unless text
    Base64.encode64(text).gsub('=','').gsub('+','-').gsub('/','_').gsub("\n",'')
  end

  def url_decode64(text)
    return nil unless text
    raise ArgumentError, 'bad format: text contains "+" or "/".' if text.include?('+') or text.include?('/')
    text = text.gsub('-','+').gsub('_','/').gsub("\n",'')
    modulo = text.length % 4
    padding = (modulo == 0) ? '' : '=' * (4 - modulo)
    Base64.decode64(text + padding)
  end

end
