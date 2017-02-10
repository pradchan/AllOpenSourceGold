'''
Created on Feb 6, 2017

@author: SIVKRISH
'''
import sys, os, csv, argparse, getpass, requests, time

sys.path.append('./')

import opchelper, logging

parser = argparse.ArgumentParser()
parser.add_argument("-i", type=str, help="identity domain")
parser.add_argument("-u", type=str, help="username")
parser.add_argument("-p", type=str, help="password")
parser.add_argument("-o", type=str, help="operations {BUILD|DELETE|SCALE|STOP|START|RESTART|VIEW|VIEW_JOB")
parser.add_argument("-w", type=str, help="web service ref file")
parser.add_argument("-l", type=str, help="logfile (fullpath)")
parser.add_argument("-d", type=str, help="json file for creating mysqlcs service", nargs='?')
parser.add_argument("-n", type=str, help="mysqlcs service name", nargs='?')
parser.add_argument("-s", type=str, help="compute shape", nargs='?')
parser.add_argument("-j", type=str, help="job number", nargs='?')
args = parser.parse_args()

iden_domain = args.i
username = args.u
password = args.p
operation = args.o
wsref_file = args.w
log_file = args.l
service_name = args.n
compute_shape = args.s
mysqlcs_def_file = args.d

# Set logging and print name of logfile to check
loglevel="INFO"
nloglevel =getattr(logging, loglevel, None)
opchelper.t_logsetting(log_file, nloglevel)
print ("\nMain: execution information in logfile %s " %log_file)
#print ("Main: DBCS Operation Request: %s " %operation)
opchelper.t_log('\n')
opchelper.t_log('Thread| Main : ' + 'MySQLCS Operation Request: ' + str(operation))

# Read Web Service Reference file into a dictionary
ws_dict = csv.DictReader(open(wsref_file))

for row in ws_dict:
    l_ops = row["OPERATION"]
    l_method = row["METHOD"]
    l_rest_endpoint = row["REST_ENDPOINT"]
    if l_ops == operation:
        opchelper.t_log('Thread| Main : ' + 'Method - ' +  str(l_method))
        opchelper.t_log('Thread| Main : ' + 'Rest Endpoint - ' +  str(l_rest_endpoint))

        job_id = opchelper.t_exec(operation, iden_domain, l_method, l_rest_endpoint, username, password, service_name, compute_shape, mysqlcs_def_file)
        print "%s: Job Id : %s" % (time.ctime(time.time()), job_id)
        if job_id > 0 :
            while True:
                    job_output = opchelper.t_viewjob (operation, iden_domain, l_rest_endpoint, username, password, job_id)
                    if job_output:
                        print "%s: Job status %s" % (time.ctime(time.time()), job_output['status'])
                        print "%s: Messages %s" % (time.ctime(time.time()), job_output['messages'])
                        print
                        if job_output['status'] in ('SUCCEED','FAILED'):
                            print "%s: Service status %s" % (time.ctime(time.time()), job_output['status'])
                            break
                    time.sleep(120)
