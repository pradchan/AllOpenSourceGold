'''
Created on Feb 7, 2017

@author: SIVKRISH
'''
import json, sys

with open ("state_json.json", "r") as myfile:
    data=myfile.readlines()

parsed_json = json.loads(data[0])

print parsed_json.get("state")
