---
layout: guide
title: Licensing
anchor: getting_started
module: getting_started/licensing
---

# Licensing
In this section we will explore how the StorageOS Portal can help you accomplish the following tasks

* Using the *MyStorageOS* Dashboard
* Manage your billing details
* Manage your payment method
* Manage your *Wallet*
* Purchase capacity
* Add an Eval license
* Assign an Array and add a Pro license
* Refer a friend

## Using the MyStorageOS Dashboard

When you first log into the MyStorageOS portal, there will be no arrays provisioned or purchased

* The figure below shows a typical Dashboard vew where a single evaluation array has been added

   ![screenshot](/images/docs/overview/licensing-01.png)

The following sections describe how to register a new array and how to purchase and assign capacity through the Dashboard


## Manage your Billing Details

Billing Details can be managed and accessed from the main menu:

1. Select *BILLING DETAILS* from the *BILLING* drop-down menu item (or click the *Update Billing Details* button if one is presented to you).
2. Fill in the required fields and click the ![image](/images/docs/overview/save.png) button

   ![screenshot](/images/docs/overview/licensing-02.png)

   Your billing details will be saved and you will be returned to your previous screen

## Manage your Payment Method

Access to your payment details is also managed from the main menu:

1. To set up payment through a credit card, select *PAYMENT METHODS* from the *BILLING* drop-down menu item
2. Enter your name and credit card information into the empty fields as illustrated below

   ![screenshot](/images/docs/overview/licensing-03.png)

3. Click on the ![image](/images/docs/overview/addpayment.png) button to complete your payment method set up

   ![screenshot](/images/docs/overview/licensing-03a.png)

## Manage your Wallet

In order to configure an array with a Professional license or to add support, you need to purchase these items in advance and then assign them to an array or arrays

1. The wallet ID (located to the top right of the window) is assigned to you when you register an account
2. To manage you wallet, click on the *MANAGE WALLET* menu item in the top menu area
3. From here you have access to delegating billing and management as well as adding capacity, licenses and support to your wallet
4. Loading your wallet is covered under **Purchasing Capacity** below

   ![screenshot](/images/docs/overview/licensing-04.png)

## Purchase Capacity

To purchase capacity, log into the MyStorageOS portal and click on the ![image](/images/docs/overview/buymore.png) button:

1. To select the number of Pro Licenses you wish to purchase, use the `+` and `-` icons
2. For more capacity, use the `+` and `-` icons
3. To purchase support slide the ![image](/images/docs/overview/on.png) button to enable it
4. Specify if you want to purchase capacity on a monthly, quarterly, annual or triennial basis by choosing the corresponding calendar icon.
5. Click the ![image](/images/docs/overview/totaltax.png) button to calculate total and tax to sum up your order

   > **Note:** You may need to update your billing details at this point if you have not done so already. Click on the *Update Billing Details* button at the bottom of the page and follow the instructions

6. Your tax and totals are updated. Click the ![image](/images/docs/overview/revieworder.png) button to review your purchase

   ![screenshot](/images/docs/overview/licensing-05.png)

7. Ensure your payment details are valid and up to date or you will be unable to continue (see **Setting up your Payment Method** above)
8. Agree to the *Terms and Conditions* by clicking the check box, and then click ![image](/images/docs/overview/placeorder.png) or ![image](/images/docs/overview/savequote.png)

   ![screenshot](/images/docs/overview/licensing-06.png)

9. Your request will be processed and you will also receive a confirmation email

   ![screenshot](/images/docs/overview/licensing-07.png)

10. If you requested a quote select *QUOTES* from the *BILLING* pull-down menu item at the top of the page to review your quote

    ![image](/images/docs/overview/licensing-08.png)

11. This will open a new page to view your saved quotes

    ![screenshot](/images/docs/overview/licensing-09.png)

## Add an Eval License

To add a license:

1. Connect to a StorageOS cluster node using a web browser and go to Configuration > License and copy the Cluster UUID onto the clipboard as you did in the previous section

2. Log back into the StorageOS portal page and select the *ARRAYS* menu item

   ![screenshot](/images/docs/overview/licensing-10.png)

3. This will bring up a new page where you will need to add a new array by clicking on the ![image](/images/docs/overview/newarray.png) button

   ![screenshot](/images/docs/overview/licensing-11.png)

4. The resulting page will prompt you to enter a unique array name - enter a name and click the ![image](/images/docs/overview/save.png) button to continue

   ![screenshot](/images/docs/overview/licensing-12.png)

5. On the next page, click on the ![image](/images/docs/overview/editbtn.png) icon to the right of the Array UUID field to edit and paste the Array UUID from your clipboard

6. Select a license option, e.g. Eval or Dev - Pro requires a purchase option (discussed above)

7. Check the Terms and Conditions check box

8. Cick on the ![image](/images/docs/overview/save.png) button to complete - a confirmation email should arrive in your mailbox

   ![screenshot](/images/docs/overview/licensing-13.png)

9. As previously stated, to add a Pro license you need to have purchased a Pro license first which will be made available in your wallet or you will receive the following notification:

   ![image](/images/docs/overview/licensing-14.png)

10. On the next page click on the ![image](/images/docs/overview/editarray.png) button towards the bottom of the window

    ![screenshot](/images/docs/overview/licensing-15.png)

11. A ![image](/images/docs/overview/genlic.png) button should appear to the top left of the page, on clicking on this, two more buttons will appear, ![image](/images/docs/overview/viewsernum.png) and ![image](/images/docs/overview/email.png) - choose one of these to obtain your license key.

    ![image](/images/docs/overview/licensing-16.png)

12. Copy the license key to you clipboard

    ![image](/images/docs/overview/licensing-17.png)

13. To install the new license key please refer to the [Configuration & Provisioning](../manage/configuring.html) section of the StorageOS documentation for further details under the **License** heading

## Assign an Array and add a Pro License

The *Assigning Array* page allows you to define a new array and *Friendly Name* and add purchase options to that array

1. Log into the StorageOS Dashboard as you did earlier in this section to view a summary of your arrays and invoices
2. Click on the ![image](/images/docs/overview/arraydetails.png) button for your unassigned array you wish to set up

   ![screenshot](/images/docs/overview/licensing-18.png)

3. From the next page, click on the ![image](/images/docs/overview/editarray.png) button to make the page editable

   ![screenshot](/images/docs/overview/licensing-19.png)

   >**Note:** If you want to add a new array instead of managing an existing array, follow the steps above under **Adding a License** to add a new array before proceeding

4. Click on the ![image](/images/docs/overview/editbtn.png) button next to *Array UUID* to edit and enter the UUID of the array you wish to register

   >**Note:** This is covered under **Licensing your Product** in the previous [Registration Section](registration.html)

5. Enable the Pro License residing in your wallet by sliding the ![image](/images/docs/overview/on.png) button
6. Add the purchased capacity from your wallet using the `+` button and assign it to the array
7. Click on the ![image](/images/docs/overview/save.png) button to complete

   ![screenshot](/images/docs/overview/licensing-20.png)

8. #### *Currently, functionality for obtaining the licesne key has yet to be implemented*

## Refer a Friend

If you refer a friend to us and they become a customer, we will give you a free month’s subscription. Refer more friends who become customers and get more free subscription!

1. Click click on the *REFER* menu item in the menu area

   ![image](/images/docs/overview/licensing-21.png)

2. Complete the Name and Email fields
2. Use the `+` to add as many referrals as you like
3. Click on the ![image](/images/docs/overview/referfriends.png) button to submit and complete

   ![screenshot](/images/docs/overview/licensing-22.png)
