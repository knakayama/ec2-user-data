ec2 user data
=============

## usage

If you use vagrant, add this line:

```shell
# change ssh port
override.ssh.port = 65467

# use user-data
aws.user_data = <<EOT
#!/bin/sh
export HOST_NAME=#{ENV['HOSTNAME']}
curl -L https://raw.githubusercontent.com/knakayama/user-data/master/user-data.sh | bash
EOT
```

or edit `#{ENV['HOSTNAME']}`.

