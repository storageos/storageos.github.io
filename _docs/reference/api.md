---
layout: guide
title: What is StorageOS?
anchor: reference/api
---

# API reference

## Tags API

Tags (or Labels) are used to customize volumes, controllers, pools and pretty much any other object that is inside StorageOS. 

### Create tag

Create new tag.

* URL: `/v1/tag`
* Method: `POST`
* Request body:

{% highlight json %}
{
"name": "dev", 
"type": "tag_type_name",
"description": ""
}
{% endhighlight %}

* Response status codes
    - Created: `201`
    - Conflict (tag with the same name already exists): `409`
* Response body (tag UUID): `46178ad4-a8d6-7db7-8ffb-a8809f9341f8`

### Get all tags

Return all tags under all tag types

* URL: `/v1/tag`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

{% highlight json %}
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
{% endhighlight %}

### Get tag type's tags

Return all tags that belong to specified tag type

* URL: `/v1/tag/{tagtype}`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

{% highlight json %}
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
{% endhighlight %}

### Tag details

Returns tag details

* URL: `/v1/tag/{tagtype}/{id}`
* Method: `GET`
* Response status code:
    - Success: `200`
* Response body:

{% highlight json %}
{
"datacentre": "dc01",
"name": "dev",
"type": "second_tagtype",
"description": "tag's description"
}
{% endhighlight %}

### Update tag

* URL: `/v1/tag/{tagtype}/{id}`
* Method: `PUT`
* Request body:

{% highlight json %}
{
"name": "new1", 
"type": "second_tagtype",
"description": "new description for this tag"
}
{% endhighlight %}

* Response status code:
    - Success: `200`
    - Bad request: `400`
* Response body (tag UUID): `46178ad4-a8d6-7db7-8ffb-a8809f9341f8`

### Delete tag

* URL: `/v1/tag/{tagtype}/{id}`
* Method: `DELETE`
* Response status code:
    - Success: `200`
    - Tag does not exist: `404`