<pre>

Header requirements:
Content-Type = application/json
x-zumo-application = NsyvgflFAzydhjsoiqiCGUilEdSolD68

Service url:
https://thearm.azure-mobile.net

TheARM Web API Documentation:
Login:
Address: /api/login
Type: POST
Example request:
{
    "username" : "peterGeorgiev11",
    "password" : "asdfghj8",
    "token" : "sadasd"
}
Returns: 
{
  "status": "success",
  "email": "nfhh@abv.bg",
  "userid": 1,
  "displayName": "mihail1",
  "os": "iOS-8.200000",
  "token": "asd"
  "companyId": 1
}

Register:
Address: /api/register
Type: POST
Example request:
{
    "username" : "peterGeorgiev11",
    "password" : "asdfghj8",
    "token" : "sadasd",
    "email" : "petar.georgiev@accedia.com",
    "displayName" : "Peter Georgiev",
    "os" : "Android"
}
Returns: 
{
  "status": "success",
  "email": "test@test.test",
  "displayName": "testuser2",
  "os": "Android",
  "token": "asd",
  "companyId": 1
}
Ping:
Address: /api/ping
Type: GET
Returns:
{
  "status": "alive"
}
All companies:
Address: /api/companies
Type: GET
Returns:
[
  {
    "companyId": 1,
    "name": "Accedia"
  }
]
Resources for company
Address: /api/{companyId}/resources
Type: GET
Parameters: company id in url
Returns:
[
  {
    "resourceId": 1,
    "image": "asd",
    "name": "Fusball",
    "company_companyId": 1
  }
]
Get data about one resource:
Address: /api/{companyId}/resources/{resourceId}
Type: GET
Parameters: company id and resource id in the url
Returns: 
{
  "resourceId": 1,
  "image": "1.png",
  "name": "Fusball",
  "company_companyId": 1,
  "rules": []
}
Create event:
Address: /api/{companyId}/events/create
Type: POST
Parameters: company id in the url
description, minUsers, maxUsers, startTime, endTime, resourceId, ownerId
Returns:
{
  "eventId": 2,
  "description": "Code created event",
  "minUsers": "2",
  "maxUsers": "4",
  "startTime": "",
  "endTime": "",
  "resource_resourceId": "1",
  "owner_userId": 1,
  "rules": [],
  "owner": {
    "userId": 1,
    "email": "nfhh@abv.bg",
    "password": "sha1$63b9f850$1$365bdb4766320b7c2cfcc9147424f2d0ccd0c01e",
    "os": "iOS-8.200000",
    "displayName": "mihail1",
    "token": "5545bbec1d2fa60f72b59e86180a5efa22a15dcb759b296ef38f1c4edb97c206"
  }
}
Get all events for company:
Address: /api/{companyId}/events
Type: GET
Parameters: company id in url
Returns:
[
  {
    "eventId": 1,
    "description": "Mass orgy",
    "minUsers": 2,
    "maxUsers": 120,
    "startTime": "2015-11-21T19:00:00.000Z",
    "endTime": "2015-11-21T19:30:00.000Z",
    "resource_resourceId": 1,
    "owner_userId": 1,
    "users": [],
    "rules": [],
    "owner": {
      "userId": 1,
      "email": "nfhh@abv.bg",
      "password": "sha1$63b9f850$1$365bdb4766320b7c2cfcc9147424f2d0ccd0c01e",
      "os": "iOS-8.200000",
      "displayName": "mihail1",
      "token": "5545bbec1d2fa60f72b59e86180a5efa22a15dcb759b296ef38f1c4edb97c206"
    }
  }
]
Get data for single event:
Address: /api/{companyId}/events/{eventid}
Type: GET
Parameters: company id and event id in url
Returns:
{
  "eventId": 1,
  "description": "Mass orgy",
  "minUsers": 2,
  "maxUsers": 120,
  "startTime": "2015-11-21T19:00:00.000Z",
  "endTime": "2015-11-21T19:30:00.000Z",
  "resource_resourceId": 1,
  "owner_userId": 1,
  "users": [],
  "rules": [],
  "owner": {
    "userId": 1,
    "email": "nfhh@abv.bg",
    "password": "sha1$63b9f850$1$365bdb4766320b7c2cfcc9147424f2d0ccd0c01e",
    "os": "iOS-8.200000",
    "displayName": "mihail1",
    "token": "5545bbec1d2fa60f72b59e86180a5efa22a15dcb759b296ef38f1c4edb97c206"
  }
}
Join event:
Address: /api/{companyId}/events/join
Type: POST
Parameters: company id in url
username, eventId
Returns: To 
{
  "status": "success"
}
Leave event:
Address: /api/:companyId/events/leave
Type: POST
Parameters: company id in url
username, eventId
Returns: 
{
  "status": "success"
}
Delete event:
Address: /api/:companyId/events/delete/:eventid/:userid
Type: DELETE
Parameters: company id, event id and user id in url
Returns:
{
  "status": "success"
}
Get resource image:
Just GET it from {server address}/images/{name of the image} 
</pre>

