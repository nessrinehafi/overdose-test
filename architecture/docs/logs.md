# Ansible Logs

## How To

By default, Ansible logs are disabled.

If you want to enable them, you have to edit the `./architecture/ansible.cfg` file, and add the following line:

```
log_path=/var/log/ansible.log
```

You can specify the log file that you want.
  
Be sure the user running Ansible has permissions on the logfile.
 
## Official Documentation

You can find mode details here:

http://docs.ansible.com/ansible/intro_configuration.html#log-path