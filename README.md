ec2 user data
=============

## usage

If you use vagrant, add this line:

```shell
#!/bin/sh
export HOST_NAME=#{ENV['HOSTNAME']}
curl -L https://raw.githubusercontent.com/knakayama/user-data/master/user-data.sh | bash
```

or edit `#{ENV['HOSTNAME']}`.

