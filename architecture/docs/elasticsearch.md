# Remove ElasticSearch from the provisioning

You must follow thoses steps:

- Remove the *myelasticsearch* alias in *provisioning/inventory/group_vars/all*
- Remove the *myelasticsearch* alias in *provisioning/inventory/group_vars/prod*
- Remove the file *provisioning/inventory/group_vars/searchservers*
- Remove all the references to *searchservers* in
    - *provisioning/inventory/lxc*
    - *provisioning/inventory/inte*
    - *provisioning/inventory/staging*
    - *provisioning/inventory/preprod*
    - *provisioning/inventory/prod*
    - *provisioning/provision.yml*
