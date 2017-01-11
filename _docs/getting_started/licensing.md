---
layout: guide
title: Licensing
anchor: getting_started
module: getting_started/licensing
---

# Licensing
In this section we will explore how the StorageOS Portal can help you accomplish the following tasks

* Manage your billing details
* Manage your payment method
* Manage your *Wallet*
* Purchase capacity
* Add an Evaluation license
* Add a Professional License
* Assign an Array
* Refer a friend

## Understanding the MyStorageOS Dashboard

When you first log into the MyStorageOS portal, there will be no arrays provisioned or purchased. 

* The figure below shows what a typical Dashboard where a single evaluation array has been added

   ![screenshot](/images/docs/overview/portal01.png)

The following sections describe how to register a new array and purchase and assign capacity


## Managing your Billing Details

To update your billing details, from the menu:

1. Choose Billing, Billing Details (or click the Update Billing Details button).
2. Fill in the required fields and click the ![image](/images/docs/overview/save.png) button

   ![screenshot](/images/docs/overview/portal02.png)

   Your billing details are saved and you are returned to your previous screen

## Setting up your Payment Method

1. To set up payment through a credit card, click Billing, Payment methods
2. Enter your name and credit card information as shown below:

   ![screenshot](/images/docs/overview/portal03.png)

## Managing your Wallet

In order to configure an array with a Professional license you need to have paid in advance. 

1. For portal customers you need to load your wallet first and then checkout and pay (see billing details). 

2. The wallet ID (located to the top right of the window) is assigned to you when you register an account

   ![screenshot](/images/docs/overview/portal04.png)

## Purchasing Capacity

To purchase capacity, log into the MyStorageOS portal and click on the ![image](/images/docs/overview/buymore.png) button:

1. Select the number of Pro Licenses you wish to purchase using the {% icon fa-plus %} and {% icon fa-minus %} icons

2. For more capacity, use the {% icon fa-plus %} and {% icon fa-minus %} icons

3. To purchase support slide the ![image](/images/docs/overview/on.png) button

4. Specify if you want to purchase capacity on a monthly, quarterly, annual or triennial basis by choosing the corresponding calendar icon.

5. Click Calculate Total and Tax to sum up your order 

   > **Note:** You may need to update your billing details at this point if you have not done so already. Click on the *Update Billing Details* button at the bottom of the page and follow the instructions 

6. Your tax and totals are updated. Click *Proceed to Review Order* to review your purchase
   
   > **Note:** You will need to ensure your payment details are valid and up to date

   ![screenshot](/images/docs/overview/portal05.png)

7. Ensure that your payment method is valid (see Setting up your payment method) 
8. Agree to the Terms and Conditions by clicking the check box, and then click *Place Order* or *Save as Quote* 

   ![screenshot](/images/docs/overview/portal06.png)

9. Your request will be processed and you will also receive a confirmation email

   ![screenshot](/images/docs/overview/licensing05.png)

10. If you requested a quote select *QUOTES* from the *BILLING* menu item at the top of the page

    ![image](/images/docs/overview/licensing07.png)

11. This will open a new page to view your saved quotes

    ![screenshot](/images/docs/overview/licensing06.png)

## Adding a License 

To add a license:

1. Connect to a StorageOS cluster node using a web browser and go to Configuration {% icon fa-arrow-right %} License and copy the Cluster UUID onto the clipboard as you did in the previous section

2. Log back into the StorageOS portal page and select the *ARRAYS* menu item

    ![screenshot](/images/docs/overview/licensing6a.png)

3. This will bring up a new page where you will need to add a new array by clicking on the ![image](/images/docs/overview/newarray.png) button
 
    ![screenshot](/images/docs/overview/licensing7a.png)

4. The resulting page will prompt you to enter a unique array name - enter a name and click the ![image](/images/docs/overview/save.png) button to continue

    ![screenshot](/images/docs/overview/licensing7b.png)

5. On the next page, click on the ![image](/images/docs/overview/editbtn.png) icon to the right of the Array UUID field and paste the Array UUID from your clipboard

6. Select a license option, e.g. Eval or Dev - Pro requires a purchase option (detailed above)

7. Check the Terms and Conditions check box

8. Cick on the ![image](/images/docs/overview/save.png) button to complete - a confirmation email should arrive in your mailbox

   ![screenshot](/images/docs/overview/licensing7c.png)

9. As previously stated, to add a Pro license you need to have previously purchased a Pro license which will be available in your wallet or you will receive the following notification:

   ![image](/images/docs/overview/licensing04.png)

10. On the next page click on the ![image](/images/docs/overview/editarray.png) button towards the bottom of the window 

    ![screenshot](/images/docs/overview/licensing7d.png)

11. A ![image](/images/docs/overview/genlic.png) button should appear to the top left of the page, after clicking on this, two more buttons will be revealed, View License Serial No. and Sent to Email - choose one of these to obtain your license key.

    ![image](/images/docs/overview/licensing7e.png)

12. Copy the key to you clipboard

    ![image](/images/docs/overview/licensing7f.png)

13. To install the new license key please refer to the [Configuration & Provisioning](../manage/configuring.html) section of the StroageOS documentation for further details under the License heading.

## Assigning an Array


1. Log into the dashboard to view a summary of your arrays and invoices
2. Click on the *Array Details* button for your unassigned array you wish to set up.

   ![screenshot](/images/docs/overview/licensing08.png)

3. Click on the *Edit Array* button

   ![screenshot](/images/docs/overview/licensing09.png)

4. Click on the ![image](/images/docs/overview/editbtn.png) button and enter the UUID of the array you wish to register
5. Enable the Pro License previously purchased residing in your wallet by sliding the ![image](/images/docs/overview/on.png) button
6. Add the prevously purchased capacity from your wallet using the {% icon fa-plus %} button and assign it to the array
7. Click on the ![image](/images/docs/overview/save.png) button to complete

   ![screenshot](/images/docs/overview/licensing10.png)


## Referring a Friend

If you refer a friend to us, and they become a customer, we will give you a free month’s subscription. 

1. Click Refer, and complete the Name and Email fields
2. Use the {% icon fa-plus %} to add as many referrals as you like
3. Click on the *Refer Friends* button to complete

   ![screenshot](/images/docs/overview/licensing11.png)




