---
layout: guide
title: StorageOS Docs - Tutorials
anchor: introduction
module: introduction/tutorials
---

# Interactive tutorials

[Our interactive tutorials](https://play.storageos.com/main) provide you with a
pre-configured StorageOS cluster, accessible from your browser without any
downloads or configuration.

<div style="margin:0 auto; width:60%">
<a href="https://my.storageos.com/sign-in?referrer=/main/tutorials">
  <img border="0" alt="StorageOS tutorials" src="../../images/tutorials.png">
</a>
</div>

<script src="//www.katacoda.com/embed.js"></script>

<script type="text/javascript">
  var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
  var windowEvent = window[eventMethod];
  var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";

  windowEvent(messageEvent,function(e) {
  var d = e.data;
  if(e && e.origin && e.origin.indexOf('katacoda.com') >= 0) {
    var t = {
      'event': 'katacoda-scenario',
      'eventName': "katacoda-" + d.scenario,
      'eventAction': d.action,
      'eventLabel': d.label
    }
    window.ga = window.ga || [];
    window.ga.push(t);
  }
  },false);
</script>

<div id="sandbox"
    data-katacoda-id="storageos/provisioning-storage"
    data-katacoda-ctatext="More" data-katacoda-ctaurl="https://my.storageos.com/main/tutorials"
    data-katacoda-color="4f5263"
    data-katacoda-secondary="61c202"
    data-katacoda-font="Helvetica Neue"
    data-katacoda-fontheader="Helvetica Neue"
    style="height: calc(100vh - 120px);">
</div>
