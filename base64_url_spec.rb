=begin
Copyright (C) 2009 Infopark AG <http://www.infopark.com/>

Run this test via: spec base64_url_spec.rb

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3 of the License,
 or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details <http://www.gnu.org/licenses/>.
=end

require 'base64_url'

describe Base64 do

  before do
    @base64_text = 'UG9seWZvbiB6d2l0c2NoZXJuZCBhw59lbiBNw6R4Y2hlbnMgVsO2Z2VsIFLDvGJlbiwgSm9naHVydCB1bmQgUXVhcms'
    @plain_text = 'Polyfon zwitschernd aßen Mäxchens Vögel Rüben, Joghurt und Quark'
  end

  describe 'when encoding' do
    it 'should return url-safe base64' do
      url_encode64(@plain_text).should == @base64_text
    end

    it 'should not contain newlines' do
      url_encode64('x' * 100).should_not include("\n")
    end

    it "should substitute url-critical characters ({ '/' => '_', '+' => '-', '[\\n=]' => '')" do
      url_encode64("#\360").should == 'I_A' # instead of "I/A=\n"
      url_encode64("#\340").should == 'I-A' # instead of "I+A=\n"
    end

    it 'should return nil, if input is nil' do
      url_encode64(nil).should be_nil
    end
  end

  describe 'when decoding' do
    it 'should return the original utf-8 string' do
      url_decode64(@base64_text).should == @plain_text
    end

    it 'should ignore newlines' do
      url_decode64("YWJjZA\n\n==\n").should == 'abcd'
      url_decode64("aW5mb3Bh\ncms").should == 'infopark'
    end

    it 'should decode a url-safe base64 string' do
      url_decode64('I_A').should == "#\360"
      url_decode64('I-A').should == "#\340"
    end

    it "should accept input strings containing trailing '='" do
      url_decode64('I-A=').should == "#\340"
      url_decode64('I-A=======').should == "#\340"
    end

    it "should reject input strings containing '/' or '+'" do
      lambda { url_decode64('abc+') }.should raise_error(ArgumentError, 'bad format: text contains "+" or "/".')
      lambda { url_decode64('abc/') }.should raise_error(ArgumentError, 'bad format: text contains "+" or "/".')
    end

    it 'should return nil, if input is nil' do
      url_decode64(nil).should be_nil
    end
  end

  it 'decoding should be the inverse of encoding' do
    text = "Dies ist ein Beispieltext, mit einigen Sonderzeichen: äÄüÜöÖß^àá-+/"
    url_decode64(url_encode64(text)).should == text

    16.times do
      bytes = ''
      (rand(32) + 8).times { bytes << rand(256) }
      encoded = url_encode64(bytes)
      url_decode64(encoded).should == bytes
    end
  end

end
