## StorageOS API username/password

{% if page.platform != "azure-aks" %}
StorageOS uses a Kubernetes secret to define the API credentials. For standard
installations (non CSI), the API credentials are used by {{ page.platform }} to
communicate with StorageOS.
{% endif %}

The API grants full access to StorageOS functionality, therefore we recommend
that the default administrative password of 'storageos' is reset to something
unique and strong.

You can change the default parameters by encoding the `apiUsername` and
`apiPassword` values (in base64) into the `storageos-api` secret.

To generate a unique password, a technique such as the following, which
generates a pseudo-random 24 character string, may be used:

```bash
# Generate strong password
PASSWORD=$(cat -e /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()_+~' | fold -w 24 | head -n 1)

# Convert password to base64 representation for embedding in a K8S secret
BASE64PASSWORD=$(echo -n $PASSWORD | base64)
```

Note that the Kubernetes secret containing a strong password *must* be created
before bootstrapping the cluster. Multiple installation procedures use this
Secret to create a StorageOS account when the cluster first starts.
