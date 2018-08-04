# Install Passbolt on K8S using Helm Charts

* Install MySQL Database.
* Installs [Passbolt](https://www.passbolt.com/) password manager.

## TL;DR;

### Your must create all the secrets (credentials, certificates) for MySQL and Passbolt. See comments in ./deploy-to-k8.sh

```console
$ ./deploy-to-k8.sh
```

Once passbolt is up and running, ssh to the passbolt pod and run the following command to create an admin user.
```
su -s /bin/bash -c "./bin/cake passbolt register_user -r admin -u [EMAIL] -f [FIRST_NAME] -l [LAST_NAME]" www-data
```

## TL;DR;

### Help
```
su -s /bin/bash -c "./bin/cake passbolt --help"
```

