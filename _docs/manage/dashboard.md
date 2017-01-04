---
layout: guide
title: Understanding the Dashboard
anchor: manage
module: manage/dashboard
---

# Understanding the Dashboard

The dashboard serves as a home screen where you can review a summary of:

1. Pools
2. Volumes
3. Rules
4. Performance

![screenshot](/images/docs/manage/dashboard.png)

The top line items, (1) Pools, (2) Volumes and (3) Rules serve as shortcuts to view and manage these configuration options.  We will discuss more about these in the next section.

## Performance Metrics

The three performance metrics charts on the second tier of the screen expose real-time data for CPU, Disk and Network object counters.

### CPU
Currently the only exposed CPU counters are average CPU percentage utilisation and the default graph breaks these down into short, mid and long term.  You can filter these out by simply clicking on the datapoint you are interested in.

![image](/images/docs/manage/cpu.png)

### Volumes

Currently the only exposed counters are average read and write disk I/O operations across all provisioned volumes.  Much as you can with the CPU views, you can filter read and write views by clicking on the datapoint you are interested in.

![image](/images/docs/manage/diskio.png)

### Network

Port I/O presently reports against network-in and network-out in bits per second (bps).  As with the other graphs you can filter out the inbound and outbound data transfer views by clicking on the datapoint you are interested in.

![image](/images/docs/manage/portio.png)

### Customising Views

While provision has been built in for changing the graphical views much of this functionality is still under development but has been exposed.  If you click on the graph name at the top a context menu will appear.

![image](/images/docs/manage/contextmenu.png)

Using the &#x2795; and &#x2796; symbols you can shrink and enlarge the graphs. The *View* property will enlarge the graph across the screen displacing the neighbouring graphs.  To reset the view, select the *Edit* control and then select *Back to dashboard* to return to the default screen.


