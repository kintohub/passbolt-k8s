#!/bin/bash

############################################# MYSQL #############################################
## Create credential secret on K8S                                                              #
#                                                                                               #
# $ kubectl create secret generic mysql-passbolt-creds -n [YOUR_NAMESPACE] \                    #
#             --from-literal=mysql-root-password=root123 \                                      #
#             --from-literal=mysql-password=passbolt123                                         #
#                                                                                               #
## Create SSL secret on K8S                                                                     #
## You might need to transform your key into RSA key (if not already the case)                  #
#                                                                                               #
# $ openssl rsa -in ./default/mysql/certs/mysql.key -out ./default/mysql/certs/mysql.key.rsa    #
#                                                                                               #
# $ kubectl create secret generic mysql-passbolt-ssl -n [YOUR_NAMESPACE] \                      #
#             --from-file=ca.pem=./default/mysql/certs/ca.pem \                                 #
#             --from-file=server-cert.pem=./default/mysql/certs/mysql.crt \                     #
#             --from-file=server-key.pem=./default/mysql/certs/mysql.key.rsa                    #
#                                                                                               #
########################################### PASSBOLT ############################################
## Create SSL secret on K8S                                                                     #
#                                                                                               #
# $ kubectl create secret generic ssl-passbolt -n [YOUR_NAMESPACE] \                            #
#             --from-file=certificate.crt=./default/passbolt/certs/certificate.crt \            #
#             --from-file=certificate.key=./default/passbolt/certs/certificate.key \            #
#             --from-file=mysql-ca.pem=./default/mysql/certs/ca.pem \                           #
#             --from-file=mysql-cert.pem=./default/mysql/certs/mysql.crt \                      #
#             --from-file=mysql-key.pem=./default/mysql/certs/mysql.key.rsa                     #
#                                                                                               #
## Create GPG secret on K8S                                                                     #
#                                                                                               #
# $ kubectl create secret generic gpg-passbolt -n [YOUR_NAMESPACE] \                            #
#             --from-file=serverkey.asc=./default/passbolt/gpg/serverkey.asc \                  #
#             --from-file=serverkey_private.asc=./default/passbolt/gpg/serverkey_private.asc    #
#                                                                                               #
#################################################################################################
############################# KEEP ALL THE CREDS AND CERTS SECURELY #############################
#################################################################################################

echo "Script to deploy passbolt and its database mysql..."
echo " Usage: ./deploy-to-k8s.sh namespace [OPTIONAL: mysql-chart]"

NS=$1
if [ -z $NS ]; then
  echo "Please provide a k8s namespace where to install passbolt and mysql"
  exit
fi

MYSQL_CHART=$2
if [ -z $NS ]; then
  MYSQL_CHART=stable/mysql
fi

helm upgrade --wait --install --namespace $NS -f ./default/mysql/values.yaml mysql-passbolt $MYSQL_CHART

while [ $(kubectl get pod -n $NS | grep mysql-passbolt | awk '{if(NR==1){print $2}}') '!=' '1/1' ]; do
  echo "Waiting for mysql to be running"
  sleep 1
done

helm upgrade --wait --install --namespace $NS -f ./default/passbolt/values.yaml passbolt ./passbolt-chart
