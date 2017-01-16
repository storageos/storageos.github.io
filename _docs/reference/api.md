---
layout: guide
title: API Reference
anchor: reference
module: reference/api
---

# API Reference

StorageOS Control plane API is accessible either through port 80 or 8000.


## Volumes API

### Create Volumes

Create new volume:

* URL: `/v1/volumes`
* Method: `POST`
* Request body:

  ```json
  {
      "name": "test volume",
      "pool": "default",
      "size": 10,
      "tags": ["replication"],
      "quantity": 1}
  ```

* Response status code:
    - Success (volume creation started): `201`
    - Volume with this name already exists: `409`
    - Request error (can be various reason, i.e. pool not found): `400`


   | Field        | Type        | Required | Description  |
   | ------------ |:-----------:| :-------:|-------------:|
   | name         | `string`    | true     | Volume name  |
   | pool         | `string`    | true     | Pool name that this volume belongs to |
   | size         | `int`       | true     | Volume size in gigabytes |
   | tags         | `[]string`  | false    | Array of tags, can be any existing tags |    
   | description  | `string`    | false    | Description |


### Get all Volumes

Returns all volumes


* URL: `/v1/volumes`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

  ```json
  [
      {
      "id":"5ef30469-feba-f1dd-7448-2dd83d9f9a31",
      "replica":false,
      "master_volume":"",
      "replica_volumes":null,
      "replica_inodes":null,
      "created_by":"storageos",
      "datacentre":"",
      "tenant":"",
      "name":"volx_17",
      "status":"active",
      "status_message":"",
      "health":"",
      "pool":"9d9f136c-53b5-e0d3-af09-dfe3919dcc69",
      "description":"",
      "size":10,
      "inode":28107,
      "volume_groups":[],
      "tags":["filesystem"],
      "controller":"12667c44-2bc1-f501-aa59-5041b262db39",
      "master_controller":"12667c44-2bc1-f501-aa59-5041b262db39",
      "replica_controllers":null,
      "virtual_controllers":["a628d7f2-8091-f4ff-d94b-ea3439d5db33","e1a16173-8099-ffff-39f4-ee7d0e138780"]
      },
      {"id":"b98a027b-1172-482e-de20-abf6aa360395",
      "replica":false,
      "master_volume":"",
      "replica_volumes":null,
      "replica_inodes":null,
      "created_by":"storageos",
      "datacentre":"",
      "tenant":"",
      "name":"vol-dev-mysql",
      "status":"failed",
      "status_message":"",
      "health":"",
      "pool":"9d9f136c-53b5-e0d3-af09-dfe3919dcc69",
      "description":"",
      "size":10,
      "inode":3546,
      "volume_groups":[],
      "tags":["filesystem"],
      "controller":"",
      "master_controller":"",
      "replica_controllers":null,
      "virtual_controllers":null
      }
  ]
  ```


### Get Volume Details

* URL: `/v1/volumes/{id}`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

  ```json
  {
  "id":"5ef30469-feba-f1dd-7448-2dd83d9f9a31",
  "replica":false,
  "master_volume":"",
  "replica_volumes":null,
  "replica_inodes":null,
  "created_by":"storageos",
  "datacentre":"",
  "tenant":"",
  "name":"volx_17",
  "status":"active",
  "status_message":"",
  "health":"",
  "pool":"9d9f136c-53b5-e0d3-af09-dfe3919dcc69",
  "description":"",
  "size":10,
  "inode":28107,
  "volume_groups":[],
  "tags":["filesystem"],
  "controller":"12667c44-2bc1-f501-aa59-5041b262db39",
  "master_controller":"12667c44-2bc1-f501-aa59-5041b262db39",
  "replica_controllers":null,
  "virtual_controllers":["a628d7f2-8091-f4ff-d94b-ea3439d5db33","e1a16173-8099-ffff-39f4-ee7d0e138780"]
  }
  ```


### Delete Volume

Deletes specified volume:

* URL: `/v1/volumes/{id}`
* Method: `DELETE`
* Response status code:
    - Success: `200`
    - Volume does not exist: `404`


## Tags API

Tags (or Labels) are used to customize volumes, controllers, pools and pretty much any other object that is inside StorageOS.

### Create Tag

Create new tag:

* URL: `/v1/tag`
* Method: `POST`
* Request body:

  ```json
  {
  "name": "dev",
  "type": "tag_type_name",
  "description": ""
  }
  ```

* Response status codes:
    - Created: `201`
    - Conflict (tag with the same name already exists): `409`
* Response body (tag UUID): `46178ad4-a8d6-7db7-8ffb-a8809f9341f8`


### Get all Tags

Return all tags under all tag types

* URL: `/v1/tag`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

  ```json
  [{
  "id": "46178ad4-a8d6-7db7-8ffb-a8809f9341f8",
  "datacentre": "",
  "name": "dev",
  "type": "second_tagtype",
  "description": ""
  }, {
  "id": "673d7866-c7d0-1967-2588-94c87da606bc",
  "datacentre": "",
  "name": "Ttttt",
  "type": "second_tagtype",
  "description": ""
  }, {
  "id": "7b6792ab-ffa0-31ca-6464-c603f62b0b24",
  "datacentre": "",
  "name": "qwe",
  "type": "second_tagtype",
  "description": ""
  }, {
  "id": "dc28b3d3-2cd1-03cc-fbf3-0fe187c6577e",
  "datacentre": "",
  "name": "Tt",
  "type": "second_tagtype",
  "description": ""
  }, {
  "id": "523891c0-f568-b340-5931-c9fc37799784",
  "datacentre": "",
  "name": "new1",
  "type": "tagtype_name",
  "description": "desc"
  }]
  ```

### Get Tag Type's Tags

Return all tags that belong to specified tag type:

* URL: `/v1/tag/{tagtype}`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

  ```json
  [{
  "id": "46178ad4-a8d6-7db7-8ffb-a8809f9341f8",
  "datacentre": "",
  "name": "dev",
  "type": "second_tagtype",
  "description": ""
  }, {
  "id": "673d7866-c7d0-1967-2588-94c87da606bc",
  "datacentre": "",
  "name": "Ttttt",
  "type": "second_tagtype",
  "description": ""
  }, {
  "id": "7b6792ab-ffa0-31ca-6464-c603f62b0b24",
  "datacentre": "",
  "name": "qwe",
  "type": "second_tagtype",
  "description": ""
  }, {
  "id": "dc28b3d3-2cd1-03cc-fbf3-0fe187c6577e",
  "datacentre": "",
  "name": "Tt",
  "type": "second_tagtype",
  "description": ""
  }]
  ```


### Tag Details

Returns tag details:

* URL: `/v1/tag/{tagtype}/{id}`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

  ```json
  {
  "datacentre": "dc01",
  "name": "dev",
  "type": "second_tagtype",
  "description": "tag's description"
  }
  ```


### Update Tag

* URL: `/v1/tag/{tagtype}/{id}`
* Method: `PUT`
* Request body:

  ```json
  {
  "name": "new1",
  "type": "second_tagtype",
  "description": "new description for this tag"
  }
  ```

* Response status code:
    - Success: `200`
    - Bad request: `400`
* Response body (tag UUID): `46178ad4-a8d6-7db7-8ffb-a8809f9341f8`


### Delete Tag

* URL: `/v1/tag/{tagtype}/{id}`
* Method: `DELETE`
* Response status code:
    - Success: `200`
    - Tag does not exist: `404`

