---
layout: guide
title: Configuration & Provisioning
anchor: manage
module: manage/configuring
---

# Configuration and Provisioning

This section explores how you can configure and provision your storage using labels, rules and auto-naming templates.

## Overview of Labels

Located under Configuration > Labels, here you can manage how you label your storage using color and text descriptions identifying and classifying your system, storage, nodes, and features in a way that makes sense to you.

Labels also let you implement naming standards for all volumes created in an environment. Essentially, this feature allows you to apply naming constructs for all your managed objects based on the default label types but also using your own user-defined labels.  These constructs allow you to build volume names from multiple labels.

StorageOS labels apply to all Configuration and Provisioning objects and fall under two categories:

### 1. Built-in Labels

There are two *Types* of Built-in label:
1. Feature (native StorageOS features)
2. Driver (native StorageOS drivers)

StorageOS features can be auto-assigned to volumes using the built-in feature *Labels* and applied using business rules (discussed later in this section). These rules are evaluated by the *Scheduler* and executed by the *Rules Engine* effectively managing data policy and placement.

### 2. User-Defined Labels

There are three *Types* of pre-configured user defined labels.  You are however free to add as many custom *Label Types* as you wish such as Department or Performance using the *NEW LABEL TYPE* control:

1. Application
2. Environment
3. Location

   ![screenshot](/images/docs/manage/labels.png)

Once you have created a new label *Type*, you can add new label *Names* beneath it and assign a *Value* and *Description* to each new name.  The label *Type* will of course be inherited from the parent in this case.



## Creating a User-Defined Label Type

Let's try this from the *Label Management* window shown above:

1. Select the ![image](/images/docs/manage/newlabeltypebtn.png) button to create a new label type
2. Provide a *label type name*, for example 'department'

   >**Note**: As soon as you start entering the new label type it will also appear in the menu on the left.

3. Provide an optional *Description*, for example 'Department name'
4. Click the ![image](/images/docs/manage/savebtn.png) button

   ![image](/images/docs/manage/newlabel.png)

5. To delete a label use the ![image](/images/docs/manage/delbtn.png) button to remove it

   ![image](/images/docs/manage/delete.png)



## Creating a User-Defined Label Name

Now we have created out label type, we are ready to create label names beneath this.  These will inherit the type *department* with the colour coded value we assigned in earlier steps.

1. Click on the ![image](/images/docs/manage/newlabelbtn.png) button to create a new label name
2. Enter the department name and description, the type will be inherited from the parent

   ![image](/images/docs/manage/newlabelname.png)

3. Click the ![image](/images/docs/manage/createbtn.png) button

   ![image](/images/docs/manage/newlabelname1.png)

4. Use the edit ![image](/images/docs/manage/editbtn.png) button to make changes to the department name label
5. Use the delete ![image](/images/docs/manage/deletebtn.png) button to remove the department name label



## Creating Rules

As introduced earlier in the labels section, *Rules* are evaluated by the *Scheduler* and executed by the *Rules Engine* effectively managing data policy and placement.  Simply put, *Rules* are created using collections of *Labels* to define a set of conditions to apply a policy to.

  ![screenshot](/images/docs/manage/rules.png)

For example, let's say we want to apply a global policy for replication that applies to all production data.  By default StorageOS has predefined Built-in and User-defined *Label Types* where these *Label Names* can be found under the following locations:

1. Configuration > Labels > ![image](/images/docs/manage/featurebtn.png) > replication
2. Configuration > Labels > ![image](/images/docs/manage/environmentbtn.png) > production

Let's create a new Built-in ![image](/images/docs/manage/featurebtn.png) Label Type rule based on the Label Name *production* under the built-in User-defined label  ![image](/images/docs/manage/environmentbtn.png) which we will apply to a volume later in this section.

1. To create a new *Rule* click on the ![image](/images/docs/manage/newrulebtn.png) button to the far right in the Rules window
2. Click in the *Name* box and enter *default replication* as the rule name
3. Click in the *Condition()* box and for this example select *Contains*
4. In the *Volume Labels* box, select *prod* which is located under the *Environment* Label Type (alternatively, below, you could apply this rule to Client Labels - StorageOS nodes)

   ![image](/images/docs/manage/newrule1.png)

5. Next, in the *Feature Labels* box, select or type *replication* which is located under the *Features* Label Type
6. Confirm the slider button is set to green (set to the right) to enable the rule
7. Click the ![image](/images/docs/manage/savebtn.png) button


   ![image](/images/docs/manage/newrule2.png)

7. This will take you back to the original window with your new rule enabled

   ![screenshot](/images/docs/manage/newrule3.png)

8. Now we have our rule, lets apply the ![image](/images/docs/manage/prodbtn.png) *Label Name* to a volume and see what happens.  Before we can do this however, we need to create a volume to apply the rule to.



## Creating Volumes and Applying Rules

When you create a new volume, rules will be automatically enforced providing these have been configured for a given *Label Name* as we have set up previously

1. To create a new volume, go to Provisioning > Volumes > ![image](/images/docs/manage/newvolumebtn.png)

   ![screenshot](/images/docs/manage/newvolume.png)

2. Provide a volume name, for example *vol-prod*
3. Give it a description, *Production volume*
4. Set a size, for example *1GB*
5. Leave *Pool* and *Quantity* at their default values (not illustrated)
5. And now add the ![image](/images/docs/manage/prodbtn.png) label we configured

   ![screenshot](/images/docs/manage/newvolume1.png)

6. Click on the ![image](/images/docs/manage/createbtn.png) to complete
7. Check the *Replicas* checkbox to reveal the new volume replica that has been created by our new Rule

   ![screenshot](/images/docs/manage/newvolume2.png)

>**Note**: The ![image](/images/docs/manage/replicationbtn.png) feature *Label Name* has been applied to the new replication rule and is now inherited by the ![image](/images/docs/manage/prodbtn.png) *Label Name*



## Auto-naming

Another option in the *Volume Management* window is the ability to automatically name volumes based on their properties based on  auto-naming template rules that have been pre-defined.

1. To create a new template, go to Configuration > Auto-naming > ![image](/images/docs/manage/newtemplatebtn.png)
2. Select *Volume* from the *Type* drop-down
3. Drag the labels you want to use for your template into the *Template* box
4. Set the counter digits for the volume name enumeration, for example 2 digits will give you 1 - 99
5. Enter a description
6. Save the template

   ![image](/images/docs/manage/autoname.png)

7. You should now see the new template with the *Type* you gave it set in order of priority for interpretation.  The up and down arrows can be used to move your template further up or down the list.

   ![image](/images/docs/manage/autoname1.png)

8. Now you are ready to auto-name a volume by selecting the labels in order as you defined them in your template earlier.
9. Click on the ![image](/images/docs/manage/createbtn.png) button to complete

   ![image](/images/docs/manage/newvolume3.png)

9. Now you can vew your new volume with the labels applied to it and the features inherited through them, namely the replication feature which we earlier, configured above.

   ![image](/images/docs/manage/newvolume4.png)



## Controllers

To view the Controllers window, select Configuration > Controllers.  

* This window provides you with a summary on the nodes participating in the cluster, their available capacity, their role and state of health.

  ![screenshot](/images/docs/manage/controllers.png)



## Drivers

To view the Drivers window, select Configuration > Drivers.  

* This window provides you with a summary on the nodes participating in the cluster and the name and type of the *Driver* they are using.

  ![image](/images/docs/manage/drivers.png)



## Caches

To view the Caches window, select Configuration > Caches.  

* The cache configuration is a global option across all Data Plane nodes.

  ![image](/images/docs/manage/caches.png)



## Diagnostics

To view the Diagnostics window, select Configuration > Diagnostics.  

* From this window you can create diagnostics bundles for a node you are experiencing issues with or for the entire cluster to post back to StorageOS for extended support.  

  ![image](/images/docs/manage/diagnostics.png)

>**Note**: Please be aware that the cluster diagnostics bundle size may vary depending on the number of nodes and amount of available log data.



## Backups

To access the Configuration Backup and Restore window, select Configuration > Backups.  

* To manage backup and restore of the control plane configuration, click on the ![image](/images/docs/manage/backupbtn.png) and ![image](/images/docs/manage/restorebtn.png) buttons to initiate a backup or restore.

  ![image](/images/docs/manage/backups.png)

>**Note**: Please be aware that during a control plane restoration the current control plane configuration will be overwritten and can not be restored without a backup for that point in time configuration.

>**Note**: Configuration data that is backed up and restored globally applies to the entire cluster.



## License

To access the License Management window, select Configuration > License.

1. To enter a new license key click on the ![image](/images/docs/manage/licensekeybtn.png) button

   ![image](/images/docs/manage/license.png)

2. Enter the license key *Name* and click on the ![image](/images/docs/manage/savebtn.png) button

   ![image](/images/docs/manage/license1.png)

>**Note**: For more information on licensing please refer to the Licensing section under *Getting Started*



## Clients

To access the Client Management window, select Provisioning > Clients.

1. From here you can configure labels for StorageOS nodes and filter the list of nodes in the cluster using labels that have been applied.  For example you may have nodes participating in a performance storage pool configured with SSDs.

2. To configure a label select the ![image](/images/docs/manage/editbtn.png) button, select the labels you want to apply and then accept the changes by clicking on the checkmark icon.

   ![image](/images/docs/manage/clients.png)

3. Clicking on the ![image](/images/docs/manage/deletebtn.png) button will delete the StorageOS node.

   ![image](/images/docs/manage/deleteclient.png)



## Pools

The Storage Pools window can be found under Provisioning > Pools.

1. The top half of the Storage Pools window allows you to view the overall status of the global pool and capacity across all nodes in the cluster and create new Storage Pools.
2. The bottom half displays the deafult stoage pool and the member nodes.

   ![image](/images/docs/manage/pools.png)



## Containers

The Containers window can be accessed under Provisioning > Containers.

1. Essentially, in the context of Docker, this window provides you with the output of `docker ps` and `docker ps -a`
2. From this window you can filter by column by typing your filter into the *Filter containers* box
3. You can also change the view for running, stopped and all (`-a`) images.

   ![screenshot](/images/docs/manage/containers.png)
