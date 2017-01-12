from OracleComputeCloud import OracleComputeCloud
import sys

username = sys.argv[1]
password = sys.argv[2]
authDomain = sys.argv[3]
url = sys.argv[4]
instancePrefix = sys.argv[5]

occ = OracleComputeCloud(endPointUrl=url, authenticationDomain=authDomain)
occ.login(user=username, password=password)

vms=occ.getIPReservations(ipReservationName='/Compute-'+authDomain+'/'+username+'/'+instancePrefix +'-IPReservation')
print (vms['ip'])