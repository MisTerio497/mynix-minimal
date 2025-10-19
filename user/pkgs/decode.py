from v2tj import convert_uri_json

uri = "vless://"
file = convert_uri_json(uri=uri)

#or Custom address & port:
#file = convert_uri_json(host="127.0.0.1", port=4142, socksport=4143, uri=uri)
# or file = convert_uri_json("127.0.0.1", 4142, 4143, uri)

# File saved at /configs
