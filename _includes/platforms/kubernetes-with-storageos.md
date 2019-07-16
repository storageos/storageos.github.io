## Kubernetes with StorageOS

Kubernetes and StorageOS communicate with each other to perform actions such as
creation, deletion or mounting of volumes. The CSI (Container Storage
Interface) driver is the standard communication method. Using CSI, Kubernetes
and StorageOS communicate over a Unix domain socket.

{% if page.platform == "azure-aks" or page.platform == "aws-eks" %}
For this platform the **only supported** setup for communication is **CSI**.
{% else %}
The former communication procedure, although still in use, uses REST API calls.
StorageOS still maintains support for it.
{% endif %}
