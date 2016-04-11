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
  "email": "petar.georgiev1@accedia.com",
  "userId": 3,
  "displayName": "Peter Georgiev",
  "username": "peterGeorgiev12",
  "os": "Android",
  "token": "sadasd",
  "companyId": 1
}

All companies:
Address: /api/companies
Type: GET
Returns:
[
  {
    "companyId": 1,
    "companyName": "Accedia"
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
    "image": "image.image",
    "name": "Fussball",
    "companyId": 1
  }
]

Get data about one resource:
Address: /api/{companyId}/resources/{resourceId}
Type: GET
Parameters: company id and resource id in the url
Returns: 
{
  "resourceId": 1,
  "image": "https://thearmstorage.blob.core.windows.net/thearmblobcontainer/40909329-Fussball-Tabelle-Icon-Lizenzfreie-Bilder.jpg",
  "name": "Fussball",
  "companyId": 1
}

Create event:
Address: /api/events/create
Type: POST
Example request:
{
    "companyId" : 1,
    "description" : "Not so unpleasent event",
    "minUsers" : 2,
    "maxUsers" : 4,
    "startTime" : "2016-12-10T12:30:00",
    "endTime" : "2016-12-10T12:30:00",
    "resourceId" : 1,
    "ownerId" : 1
}
Returns:
{
  "eventId": 15,
  "description": "Not so unpleasent event",
  "minUsers": 2,
  "maxUsers": 4,
  "startTime": "2016-12-10T12:30:00Z",
  "endTime": "2016-12-10T12:30:00Z",
  "resource_resourceId": 1,
  "owner_userId": 1,
  "rules": [],
  "owner": {
    "status": "success",
    "email": "petar.georgiev@accedia.com",
    "userId": 1,
    "displayName": "Peter Georgiev",
    "username": "peterGeorgiev11",
    "os": "Android",
    "token": "sadasd",
    "companyId": 1
  },
  "users": [
    {
      "status": "success",
      "email": "petar.georgiev@accedia.com",
      "userId": 1,
      "displayName": "Peter Georgiev",
      "username": "peterGeorgiev11",
      "os": "Android",
      "token": "sadasd",
      "companyId": 1
    }
  ]
}

Get all events for company:
Address: /api/{companyId}/events
Type: GET
Parameters: company id in url
Returns:
[
  {
    "eventId": 12,
    "description": "Not so unpleasent event",
    "minUsers": 2,
    "maxUsers": 4,
    "startTime": "2016-12-10T12:30:00Z",
    "endTime": "2016-12-10T12:30:00Z",
    "resource_resourceId": 1,
    "owner_userId": 1,
    "rules": [],
    "owner": {
      "status": "success",
      "email": "petar.georgiev@accedia.com",
      "userId": 1,
      "displayName": "Peter Georgiev",
      "username": "peterGeorgiev11",
      "os": "Android",
      "token": "sadasd",
      "companyId": 1
    },
    "users": [
      {
        "status": "success",
        "email": "petar.georgiev@accedia.com",
        "userId": 1,
        "displayName": "Peter Georgiev",
        "username": "peterGeorgiev11",
        "os": "Android",
        "token": "sadasd",
        "companyId": 1
      }
    ]
  }
]

Get data for single event:
Address: /api/events/{eventid}
Type: GET
Parameters: event id in url
Returns:
{
  "eventId": 12,
  "description": "Not so unpleasent event",
  "minUsers": 2,
  "maxUsers": 4,
  "startTime": "2016-12-10T12:30:00Z",
  "endTime": "2016-12-10T12:30:00Z",
  "resource_resourceId": 1,
  "owner_userId": 1,
  "rules": [],
  "owner": {
    "status": "success",
    "email": "petar.georgiev@accedia.com",
    "userId": 1,
    "displayName": "Peter Georgiev",
    "username": "peterGeorgiev11",
    "os": "Android",
    "token": "sadasd",
    "companyId": 1
  },
  "users": []
}

Join event:
Address: /api/events/join
Type: POST
Example request:
{
    "userId" : 1,
    "eventId" : 8
}
Returns:  
{
  "status": "succesful",
  "message": "Event joined successful."
}

Leave event:
Address: /api/events/leave
Type: POST
Example request:
{
    "userId" : 1,
    "eventId" : 8
}
Returns: 
{
  "status": "succesful",
  "message": "Event left successful."
}

Delete event:
Address: /api/events/delete
Type: DELETE
Example request
{
    "userId" : 1,
    "eventId" : 11
}
Returns:
{
  "status": "succesful",
  "message": "Delete event successful."
}
Get resource image:
Just GET it from the given url
</pre>

