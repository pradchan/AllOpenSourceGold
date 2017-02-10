'''
Created on Feb 6, 2017

@author: SIVKRISH
'''
import logging, requests, json

def t_logsetting(logfile, loglevel):

    logging.basicConfig(level=loglevel,
                        format='%(asctime)s %(levelname)-8s %(message)s',
                        datefmt='%a, %d %b %Y %H:%M:%S',
                        filename=logfile,
                        filemode='a')

def t_log(logmessage):
    logging.info(logmessage)
    
def t_translateops(operation):
    "function to translate operation to operation type for View Job REST API"

    switcher = {
        "BUILD":"create",
        "DELETE":"delete",
        "SCALE":"scale",
        "STOP":"control",
        "START":"control",
        "RESTART":"control"
    }
    return switcher.get(operation,"undefined")

def t_exec(operation, iden_domain, l_method, l_rest_endpoint, username, password, service_name, compute_shape, mysqlcs_def_file):

    url = l_rest_endpoint
    headers = { 
                  'X-ID-TENANT-NAME':iden_domain, 
                  'Content-Type':'application/vnd.com.oracle.oracloud.provisioning.Service+json',
                  'Accept':'application/json'
              }    
    
    if operation == 'VIEW':
        headers = { 
                      'X-ID-TENANT-NAME':iden_domain, 
                      'Accept':'application/json'
                  }    
        url = url + '/paas/api/v1.1/instancemgmt/' + iden_domain + '/services/MySQLCS/instances/' + service_name
        try:
           response = requests.get(url, headers=headers, auth=(username,password))
        except Exception as e:
           t_log('An error occurred : %s\n' % e)
           raise
        if response.status_code == 200:
            parsed_response = json.loads(response.text)
            print 'Status of ' + parsed_response['serviceName'] + ' - ' + parsed_response['state']
            print 'check logfile for detailed information ...'
            t_log(response.text)
            g_jobid = 0
        else :
            t_log('Job request not accepted - Response code %s' % response.status_code)
            g_jobid = 0
            
    elif operation == 'STOP':
        url = url + '/paas/api/v1.1/instancemgmt/' + iden_domain + '/services/MySQLCS/instances/' + service_name + '/hosts/stop'
        data = {"allServiceHosts":"true","force":"true"}
        try:
            response = requests.post(url, headers=headers, auth=(username,password), data=json.dumps(data) )
        except Exception as e:
            t_log('An error occurred : %s\n' % e)
            raise
        if response.status_code == 202:
            job_id = response.headers['Location'].split("/")
            t_log('Job Id : %s' % job_id[len(job_id)-1])
            g_jobid = job_id[len(job_id)-1]
        else :
            t_log('Job request not accepted - Response code %s' % response.status_code)
            g_jobid = 0

    elif operation == 'START':
          url = url + '/paas/api/v1.1/instancemgmt/' + iden_domain + '/services/MySQLCS/instances/' + service_name + '/hosts/start'
          data = {"allServiceHosts":"true","force":"true"}
          try:
             response = requests.post(url, headers=headers, auth=(username,password), data=json.dumps(data) )
          except Exception as e:
             t_log('An error occurred : %s\n' % e)
             raise
          if response.status_code == 202:
             job_id = response.headers['Location'].split("/")
             
             t_log('Job Id : %s' % job_id[len(job_id)-1])
             g_jobid = job_id[len(job_id)-1]
          else :
             t_log('Job request not accepted - Response code %s' % response.status_code)
             g_jobid = 0
             
    elif operation == 'RESTART':
          url = url + '/paas/api/v1.1/instancemgmt/' + iden_domain + '/services/MySQLCS/instances/' + service_name + '/hosts/restart'
          data = {"allServiceHosts":"true","force":"true"}
          try:
             response = requests.post(url, headers=headers, auth=(username,password), data=json.dumps(data) )
          except Exception as e:
             t_log('An error occurred : %s\n' % e)
             raise
          if response.status_code == 202:
             job_id = response.headers['Location'].split("/")
             
             t_log('Job Id : %s' % job_id[len(job_id)-1])
             g_jobid = job_id[len(job_id)-1]
          else :
             t_log('Job request not accepted - Response code %s' % response.status_code)
             g_jobid = 0
             
    elif operation == 'SCALE':
          url = url + '/paas/api/v1.1/instancemgmt/' + iden_domain + '/services/MySQLCS/instances/' + service_name + '/hosts/scale'
          data = {"components":{"mysql":{"shape":"oc3","hosts":["mytestinstance-mysql-1"]}}}
          try:
             response = requests.put(url, headers=headers, auth=(username,password), data=json.dumps(data) )
          except Exception as e:
             t_log('An error occurred : %s\n' % e)
             raise
          if response.status_code == 202:
             job_id = response.headers['Location'].split("/")
             
             t_log('Job Id : %s' % job_id[len(job_id)-1])
             g_jobid = job_id[len(job_id)-1]
          else :
             t_log('Job request not accepted - Response code %s' % response.status_code)
             t_log(response.headers)
             g_jobid = 0

    elif operation == 'BUILD':
          url = url + '/paas/api/v1.1/instancemgmt/' + iden_domain + '/services/MySQLCS/instances'
          try:
             json_file =  open(mysqlcs_def_file,'r')
             json_str = json_file.read()
             json_data = json.loads(json_str)
          except Exception as e:
             t_log('An error occurred in processing dbcs json file: %s\n' % e)
          try:
             response = requests.post(url, headers=headers, auth=(username,password), data=json.dumps(json_data) )
          except Exception as e:
             t_log('An error occurred : %s\n' % e)
             raise
          if response.status_code == 202:
             job_id = response.headers['Location'].split("/")
             
             t_log('Job Id : %s' % job_id[len(job_id)-1])
             g_jobid = job_id[len(job_id)-1]
          else :
             t_log('Job request not accepted - Response code: %s' % response.status_code)
             t_log('Response Message: %s ' % response.text)
             g_jobid = 0

    elif operation == 'DELETE':
          url = url + '/paas/api/v1.1/instancemgmt/' + iden_domain + '/services/MySQLCS/instances/' + service_name
          data = {}
          try:
             response = requests.post(url, headers=headers, auth=(username,password), data=json.dumps(data) )
          except Exception as e:
             t_log('An error occurred : %s\n' % e)
             raise
          if response.status_code == 202:
             job_id = response.headers['Location'].split("/")
             
             t_log('Job Id : %s' % job_id[len(job_id)-1])
             g_jobid = job_id[len(job_id)-1]
          else :
             t_log('Job request not accepted - Response code %s' % response.status_code)
             g_jobid = 0

    return g_jobid
     
def t_viewjob (operation, iden_domain, l_rest_endpoint, username, password, jobid):
    "function to return status of a job "
    
    url = l_rest_endpoint + '/paas/api/v1.1/activitylog/' + iden_domain + '/job/' + str(jobid)
    #print 'view job url', url

    headers = { 
                  'X-ID-TENANT-NAME':iden_domain, 
                  'Accept':"application/json"
              }    
              
    try:
       response = requests.get(url, headers=headers, auth=(username,password))
    except Exception as e:
       t_log('An error occurred in view job status: %s\n' % e)
       raise
    try:
       parsed_response = json.loads(response.text)
       t_log(response)
       t_log('Job Opeartion ' + parsed_response['operationType'])
       t_log('Job Status ' + parsed_response['status'])
       t_log(parsed_response['messages'])
    except ValueError as e:
       t_log('Malformed Json file')
       parsed_response = {}
    return parsed_response

if __name__ == "__main__":

    l_logfile='/tmp/pythontest.log'
    l_loglevel=logging.INFO
    
    t_logsetting(l_logfile, l_loglevel)
    
    t_log('A DEBUG MESSAGE')
    t_log('An Error Message')
    t_log('A Warning  Message')
