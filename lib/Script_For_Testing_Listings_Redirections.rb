require 'curb'
=begin
  This Script does not run in Rails, is run to check that redirections are good
  Created at: February 10th / 2016
=end
counter = 1
File.open('/Users/danilogarcia024/apc-directory/lib/Duplicate_Listings_Information_Completed.csv', 'w') { |file|
  File.open('/Users/danilogarcia024/apc-directory/lib/Duplicate_Listings_Information.csv', "r").each_line do |line|
    begin
      items = line.strip.split(',')
      duplicate_listing_id = items[1]
      original_url = items[3]
      redirected_url = items[5]

      c = Curl::Easy.new(original_url)
      c.http_auth_types = :basic
      c.username = 'staging'
      c.password = '7oD4RM4NikfhVu'
      c.perform

      real_redirected_url = c.redirect_url

      file.write("Id,#{duplicate_listing_id},Original url,#{original_url},Redirected url,#{redirected_url}, Real redirected url,#{real_redirected_url}, Response code,#{c.response_code},Status,#{real_redirected_url == redirected_url ? 'OK' : 'ERROR'}\r\n")
    rescue

    end
    p "Number of Records processed: #{counter}"
    counter+=1
    sleep 1
  end
}
