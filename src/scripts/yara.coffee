# Description:
#   Generate Yara Rule with strings
#
# Dependencies:
#   None
#
# Configuration:
#   None…
#
# Commands:
#   hubot yara template- Generates default rule template
#
# Author:
#   Scott J Roberts - @sroberts

module.exports = (robot) ->
  robot.respond /yara template/i, (msg) ->
    # name (*.) cat (*.)
    # Default Values
    yara_rule_name = "rule_name"
    yara_rule_category = "category"
    yara_meta_author = msg.message.user.name
    today = new Date
    dd = today.getDate()
    mm = today.getMonth() + 1
    yyyy = today.getFullYear()
    if dd < 10
      dd = '0' + dd
    if mm < 10
      mm = '0' + mm
    yara_meta_date = yyyy + "-" + mm + "-" + dd
    yara_meta_description = "Default Rule Template"
    yara_strings_list = ['foo', 'bar', 'baz']

    # If there's strings generate rule with strings

    # Generate Strings Section
    # yara_conditions = 0
    # yara_strings_parsed = ""
    #
    # for yara_string in yara_strings_list
    #   yara_strings_parsed += "    string#{yara_conditions} '#{yara_string}'\n"
    #   yara_conditions++

    new_rule = """
    rule #{yara_rule_name} : #{yara_rule_category}
    {
      meta:
        author = '#{yara_meta_author}'
        date = '#{yara_meta_date}'
        description = '#{yara_meta_description}'
      strings:
        $string0 = "foo"
        $string1 = "bar"
        $string2 = "baz" wide
    condition:
        3 of them
    }
    """
    msg.send new_rule
