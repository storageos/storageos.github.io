---
layout: guide
title: Configuring the environment
anchor: manage
module: emanage/configuring
---

# Configuring your storage environment

## Labels
StorageOS labels aply to all Configuration and Provisioning objcts and fall under two categories:

### Built-in Labels
There are two *Types* of Built-in label:
1. Feature (native StorageOS features)
2. Driver (native StorageOS drivers)

StorageOS features can be auto-assigned to volumes using the built-in feature *labels* and applied using business rules (dicussed later in this section). These rules are evaluated by the *Scheduler* and executed by the *Rules Engine* effectively managing data policy and placement.

### User-Defined Labels
There are three *Types* of pre-configured user defined labels.
1. Application
2. Environment
3. Location

You are however free to add as many custom Types as you wish such as Department or Performance using the *NEW LABEL TYPE* control:

   ![screenshot](/images/docs/explore/labels.png)

From the Labels link, you can manage how you label your storage using color and text descriptions identifying and classifying your system, storage, nodes, and features in a way that makes sense to you.

These labels also let you implement naming standards for all volumes created in an environment. Essentially, this feature allows you to apply naming constructs for all your managed objects based on the default label types but also using your own user-defined labels.  These constructs allow you to build volume names from multiple labels.

### Creating a new label type
To create a new label:

1. Scroll to the bottom of the Label Management window and click __New Label Type__.

 ![image](/images/docs/user/Labels3.png)

 You can then create a business unit type by choosing __New Label__ in the Business Unit section, giving it a name and type, then clicking __Save__.

 ![image](/images/docs/user/Labels4.png)

2. At the top of the window, enter a name for the label type, choose a color, then click __Save__. A message box indicates that your label has been saved, and the new label (Business Unit in this example), appears in the Label Management menu.

 ![image](/images/docs/user/Labels5.png)

 ![image](/images/docs/user/Labels2.png)


## Controllers

1. You can see the nodes....

 ![image](/images/docs/user/Controllers.png)


## Drivers
To review the drivers installed under the control of StorrageOS, click the __Drivers__ menu option. You can expand the information displayed by clicking over to the right of your screen as highlighted:

 ![image](/images/docs/user/Drivers.png)


## Auto-naming

 ![image](/images/docs/user/AutonamingTemplate1.png)

 ![image](/images/docs/user/AutonamingTemplate2.png)


## rules

## Backups
