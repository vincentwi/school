# coding: utf-8

# In[60]:


# import the required libraries 
from googleapiclient.discovery import build 
from google_auth_oauthlib.flow import InstalledAppFlow 
from google.auth.transport.requests import Request 
import pickle 
import os.path 
import base64  #for decoding
import email 
import pandas as pd
import re 
import os
from bs4 import BeautifulSoup  #for reading the data

# In[8]:


# Define the SCOPES.
SCOPES = ['https://www.googleapis.com/auth/gmail.readonly'] 


# In[32]:


#Function that will be used to find and count the urls in the emails
def Find(string): 
    regex = r"(?i)\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'\".,<>?«»“”‘’]))"
    url = re.findall(regex, string)   
    if len(url) > 0:
        return [x[0] for x in url] 
    else:
        return []


#function that will identify count of chars in body of email
def chars_in_body(body_email):
    if len(str(body_email[0])) == 2:
        try:
            return len(str(body_email[0][0]))
        except:
            return len(str(body_email[0]))  
    else:
        return len(str(body_email[0]))


#function to retrieve user's emails (used by ML.py)
def getEmails(): 
    print("Please login through the pop-up or link below")
    list_email = [] 
    try_list = []
    creds = None 
    
    
    # Ask the user to log in. 
    if not creds or not creds.valid: 
        if creds and creds.expired and creds.refresh_token: 
            creds.refresh(Request()) 
        else:  #please change directories to your folder
            flow = InstalledAppFlow.from_client_secrets_file( os.path.join(os.getcwd()[:-17],'credentials.json'), SCOPES) 
            creds = flow.run_local_server(port=0) 

    
    # Connect to the Gmail API 
    service = build('gmail', 'v1', credentials=creds) 
  
    
    # request a list of all the messages 
    print("\n","Getting Emails")
    result = service.users().messages().list(userId='me').execute() 
 
    
    # messages is a list of dictionaries where each dictionary contains a message id. 
    messages = result.get('messages') 
  
    print("Got emails. Parsing for important information, takes about 4s per mail")
    # iterate through all the messages 
    for msg in messages: 
        # Get the message from its id 
        emailDict = service.users().messages().get(userId='me', id=msg['id']).execute() 
  
        
        # Get the data that matters 
        payload = emailDict['payload'] 
        headers = payload['headers']

        
        # Initializing the data so that we don't get any errors and have a None value in the DataFrame
        date, mail_type, cc, bcc, org, tld, chars_in_subject = None, None, None, None, None, None, None
        subject, sender, body_email, unsubscribe             = None, None, [[]], None

        
        # Look for data in the headers
        for i in headers: 
            if i['name'] == 'Subject': 
                subject = i['value'] 
            if i['name'] == 'From': 
                sender = i['value']
            if i['name'] == 'Date':
                date = i['value']
            if i['name'] == 'From': 
                tld = i['value'].split('@')[1].split('.')[0]
            if i['name'] == 'From': 
                org = i['value'].split('@')[1].split('.')[1].split('>')[0]
            if i['name'] == 'CC':
                cc = len(i['value'].split(','))
            if i['name'] == 'Bcc':
                bcc = len(i['value'].split(','))
            if i['name'] == 'Content-Type': 
                mail_type = i['value']
            if i['name'] == 'List-Unsubscribe': 
                unsubscribe = i['value']
        
        
        # Look for more data, hopefully (reason why we have a 'try' statement)
        try:
            # The Body of the message is in Encrypted format. So, we have to decode it. 
            # Get the data and decode it with base 64 decoder. 
            parts = payload.get('parts')[0] 
            data = parts['body']['data'] 
            data = data.replace("-","+").replace("_","/") 
            decoded_data = base64.b64decode(data) 

            
            # Now, the data obtained is in lxml. So, we will parse  
            # it with BeautifulSoup library 
            soup = BeautifulSoup(decoded_data , "lxml") 
            body_email = soup.body() 

            
            # Creating a cool dict with all the data needed 
            list_email.append({'emailDict' : emailDict, 'Subject': subject, 'From' : sender, 'Message' : body_email, 'Unsubscribe': unsubscribe})
            try_list.append({'date': date, 'tld': tld, 'org': org, 'urls': len(Find(str(body_email))), 'cc' : cc, 'bcc' : bcc,
                         'chars_in_subject' : len(subject), 'chars_in_body' : chars_in_body(body_email), 'mail_type': mail_type})
            
        
        # If we reach this step there might be a problem!
        except:
            list_email.append({'emailDict' : emailDict, 'Subject': subject, 'From' : sender, 'Message' : body_email, 'Unsubscribe': unsubscribe})
            try_list.append({'date': date, 'tld': tld, 'org': org, 'urls': len(Find(str(body_email))), 'cc' : cc, 'bcc' : bcc,
                         'chars_in_subject' : len(subject), 'chars_in_body' : chars_in_body(body_email), 'mail_type': mail_type})
        
    #return dict with two dicts
    # list_email has information to be presented to the user on Django
    # try_list has information to be used by our ML algorithm  
    return {'list_mail': list_email, 'try_list': try_list}



