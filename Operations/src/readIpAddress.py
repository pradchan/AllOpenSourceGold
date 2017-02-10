'''
Created on Feb 6, 2017

@author: SIVKRISH
'''
import json, sys

with open ("Operations/src/ip_json.json", "r") as myfile:
    data=myfile.readlines()

parsed_json = json.loads(data[0])
print parsed_json.get("components").get("mysql").get("attributes").get("CONNECT_STRING").get("value")
