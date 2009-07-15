=begin
Copyright (C) 2009 Infopark AG <http://www.infopark.com/>

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3 of the License,
 or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details <http://www.gnu.org/licenses/>.
=end

require 'base64'

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
