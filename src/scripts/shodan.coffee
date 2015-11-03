# Description:
#   Search Shodan based on https://developers.shodan.io/shodan-rest.html
#
# Dependencies:
#   None
#
# Configuration:
#   SHODAN_API_KEY - Sign up at http://www.shodanhq.com/api_doc
#
# Commands:
#   hubot shodan <string> - Search Shodan for any information about string
#
# Author:
#   Scott J Roberts - @sroberts

SHODAN_API_KEY = process.env.SHODAN_API_KEY

api_url = "https://api.shodan.io"

module.exports = (robot) ->
  robot.respond /shodan (.*)/i, (msg) ->

    if SHODAN_API_KEY?
      shodan_term = msg.match[1].toLowerCase()

      request_url = api_url + "/shodan/host/#{shodan_term}?key=#{SHODAN_API_KEY}"

      robot.http(request_url)
        .get() (err, res, body) ->

          if res.statusCode is 200
            shodan_json = JSON.parse body

            if shodan_json.error
              shodan_profile = "Shodan didn't tell me anything useful about #{shodan_term}"

            else

              shodan_profile = """Here's what I found on Shodan for #{shodan_term}

              - IP:  #{shodan_json.ip}
              - Geo: #{shodan_json.city}, #{shodan_json.region_name}, #{shodan_json.country_name}

              """

              for host in shodan_json.data
                banner_array = host.banner.split "\r\n"

                banner_string = ""
                banner_string += " - #{banner_item}\n" for banner_item in banner_array when banner_item != ''
                shodan_profile += "\n~ #{host.ip}\n------\n- Hostname:     #{host.hostnames.toString()}\n- Organization: #{host.org}\n- Port:         #{host.port}\n- Banner:       \n#{banner_string}"

            msg.send shodan_profile
          else
            msg.send "I couldn't access #{api_url}. What I do know is just this: Error Message: #{err}. Status Code: #{res.statusCode}"

    else
        msg.send "Shodan API key not configured. Get one at http://www.shodanhq.com/api_doc"
