import urllib2
import sys

def build_opener_urllib(protocol="http", user=1):
	with open("proxy.dat","r") as file:
		[proxy_addr, port] = file.readline().split()
	prefix = ""
	if user:
		with open("auth.dat", "r") as file:
			username = file.readline()
			password = file.readline()
		prefix = username+":"+password+"@"
	
	proxy = urllib2.ProxyHandler({protocol: "http://"+prefix+proxy_addr+":"+port})

	auth = urllib2.HTTPBasicAuthHandler()
	return urllib2.build_opener(proxy, auth, urllib2.HTTPHandler)

if __name__=="__main__":
	try:
		from BeautifulSoup import BeautifulSoup
	except:
		
	url_opener = urllib2.build_opener()
	index = sys.argv[1].find(":")
	if sys.argv[2] == "proxy": 
		url_opener = build_opener_urllib(sys.argv[1][:index], sys.argv[3])
	print "Connecting "+sys.argv[1]+" for password....."
	request = url_opener.open(sys.argv[1])
	soup = BeautifulSoup(request.read())
	table = soup.find(id="openvpn")
	password = str(table.findAll("li")[-1]).split()[1]
	index = password.find('<')
	password = password[:index]
	if len(password) == 8:
		with open("authv.dat", "w") as file:
			file.write("vpnbook\n")
			file.write(password)

	
