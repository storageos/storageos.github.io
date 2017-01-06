---
layout: guide
title: Licensing
anchor: overview
module: overview/licensing
---

# Licensing

In this section we will explore the following topics:

* Setting up your *MyStorageOS* account
* Downloading and installing StorageOS
* Understanding license types
* Understanding the *MyStorageOS* Dashboard


## Setting up your StorageOS Account

Before you can access support, purchase a license or set up billing, you need to setup a StorageOS account which involves the following steps:

* Create your account
* Verify your email address
* Set up your account details

### Create your Account
To create a StorageOS account

1.	Navigate to the StorageOS home page URL at http://storageos.com in a new browser window and click the <img src="/images/docs/overview/getstarted.png" height="21"> button to begin

    ![screenshot](/images/docs/overview/licensing1.png)

2. This will take you to the my.storageos.com web portal where you can register and create an account
3. From here you have the choice of creating a StorageOS sign in or alternatively, you can use GitHub, LinkedIn or Google providers to manage your sign in	
4. To create a StorageOS sign in, enter your email address and create a new password and click the <img src="/images/docs/overview/signup.png" height="21"> button to proceed to the next step

   ![screenshot](/images/docs/overview/licensing2.png)

   > **Note:** It is recommended you follow sound guidelines for creating a strong password using least 8-12 characters in length and includes numbers, symbols, capital and lower-case letters


### Verify your Email Address
1. After clicking the <img src="/images/docs/overview/signup.png" height="21"> button, you will need to check your email for a message from *StorageOS Customer Success* with a link to activate your new account

   ![screenshot](/images/docs/overview/licensing3.png)

   > **Note:**  If you do not receive the email, check your Junk email folder for a *StorageOS Customer Success* email

   > **Note:**  Do not reply to this email as the account is not monitored - for support, go to http://support.storageos.com/.

2. Click on the email link to take you to the StorageOS confirmation page and then click the <img src="/images/docs/overview/toportal.png" height="21"> button

   ![screenshot](/images/docs/overview/licensing4.png)

3. Enter the login information that you just configured, click on the <img src="/images/docs/overview/login.png" height="21"> button 

   ![screenshot](/images/docs/overview/licensing4a.png)

### Setup your Account Details

To set up your StorageOS account

1. On the Account Setup screen enter complete all of the requested fields

   * Enter your name and company (email address is auto-populated)
   * Enter the country where your phone numbers are located and enter the phone numbers for each
   * Complete the remaining address fields

2. Click the <img src="/images/docs/overview/save.png" height="21"> button

    ![screenshot](/images/docs/overview/licensing4b.png)

3.	You can now continue to the next step and download StorageOS

## Downloading and Installing StorageOS

Once you’ve created and saved your account details, you’ll be directed to the download page to download and install the StorageOS. 

At this point you need to refer to the the Installation Guide for further guidance on the download option you want to select.  Scroll down to the the Deployment Options heading in the [Installation Requirements](../install/deployment.html) section of the StroageOS documentation for further details.

1.	From the StorageOS portal, read the license agreement and click the agreement check box to accept and proceed
2.	Click on the installation method you wish to install to begin the StorageOS download

    ![screenshot](/images/docs/overview/licensing5.png)

3.	Once your download completes you can begin the product installation by following the instructions in the [Installation Guide](../install/deployment.html) before returning to these instructions to license your new array. 


## Licensing your Product

Once you have completed the software installation you will need to install a valid license key based on the license type you have chosen

1.	Connect to any StorageOS cluster node using a web browser and go to Configuration {% icon fa-arrow-right %} License and copy the Cluster UUID onto the clipboard

    ![screenshot](/images/docs/overview/license.png)

2. From the StorageOS portal, you'll need to *Create a New Array*; to do this you need to select the Arrays menu

    ![screenshot](/images/docs/overview/licensing6a.png)

3. This will bring up a new page where you can add a new array by clicking on the New Array button

    ![screenshot](/images/docs/overview/licensing7a.png)

4. The next page will prompt you to enter a unique array name - click the <img src="/images/docs/overview/save.png" height="21"> button to continue

    ![screenshot](/images/docs/overview/licensing7b.png)

5. Click on the edit icon to the right of the Array UUID field and paste the Array UUID from your clipboard

6. Select a license option

7. Check the Terms and Conditions check box

8. Cick on the <img src="/images/docs/overview/save.png" height="21"> button to complete - a confirmation email should arrive in your mailbox

    ![screenshot](/images/docs/overview/licensing7c.png)

9. On the next page click on the Edit Array button towards the bottom of the window 

    ![screenshot](/images/docs/overview/licensing7d.png)

10. A Generate License Serial No. button should appear to the top left of the page, after clicking on this, two more buttons will be revealed, View License Serial No. and Sent to Email - choose one of these to obtain your license key.

    ![image](/images/docs/overview/licensing7e.png)

11. Copy the key to you clipboard

    ![image](/images/docs/overview/licensing7f.png)

4.	To install the new license key please refer to the [Configuration & Provisioning](../manage/configuring.html) section of the StroageOS documentation for further details under the License heading.

You can now request and purchase additional storage.

## Understanding License Types

Now that you have registered your storage array and have your license (through email), your billing and payment information are asset up in your MyStorage account, you can purchase Storage from StorageOS through the MyStorageOS portal.

You can purchase one of three license types through the licensing portal

* Evaluation (Eval License)
* Professional (Pro License)
* Developer (Dev License) 

1. The following table details each license type


   | Type             | Description                                  | Commercials |
   |:-----------------|:---------------------------------------------|:------------|
   | **Evaluation**   | ▪︎ Full functionality                         | ▪︎ Free      |
   |                  | ▪︎ 10 TB maximum capacity                     |             |
   |                  | ▪︎ 30-day restriction (defaults to Developer if no subscription purchased)|           |
   | **Professional** | ▪ Full Functionality                         | ▪ Subscription in advance for annual  |
   |                  | ▪ 1TB included                               | ▪ Subscription annually in advance for 3 year   |
   |                  | ▪ Additional capacity in 100GB increment     | ▪ Discounts for annual and 3 year subscriptions |
   |                  | ▪ 30-day, 90-day, annual, and 3-year license |             |
   |                  | ▪ Auto renewal                               |             |
   | **Developer**    | ▪ Limited functionality (no HA or encryption)| ▪︎ Free      |
   |                  | ▪ Unlimited capacity                         |             |
   |                  | ▪ No time restrictions                       |             |

You can request one of three license types through the licensing portal discussed in the next section.
