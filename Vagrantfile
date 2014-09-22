# -*- mode: ruby -*-
# vim: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box     = "ec2"
    config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.provider :aws do |aws, override|
        override.ssh.username         = ENV["AWS_SSH_USERNAME"]
        override.ssh.private_key_path = ENV["AWS_SSH_KEY_PATH"]
        override.ssh.pty              = false
        override.ssh.port             = ENV['PORT']

        aws.access_key_id     = ENV["AWS_ACCESS_KEY_ID"]
        aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
        aws.keypair_name      = ENV["AWS_KEYPAIR_NAME"]
        aws.region            = ENV["REGION"]
        aws.ami               = ENV["AMI"]
        aws.instance_type     = ENV["INSTANCE_TYPE"]
        aws.security_groups   = [ENV["AWS_SECURITY_GROUP"]]
        aws.tags              = {
            "Name"        => "test",
            "Description" => "test",
        }
        aws.elastic_ip        = ENV["ELASTIC_IP"]
        aws.user_data         = <<EOT
#!/bin/sh
export HOST_NAME=#{ENV['HOSTNAME']}
export PORT=#{ENV['PORT']}
curl -L https://raw.githubusercontent.com/knakayama/user-data/master/user-data.sh | bash
EOT
    end
end

