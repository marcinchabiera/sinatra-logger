## Locally
    bundle exec rackup -p 4567
    open http://localhost:4567

## AWS - setup env manually
    sudo yum update
    sudo yum install -y ruby24
    sudo alternatives --set ruby /usr/bin/ruby2.4
    gem install bundle
    sudo yum install git 
    git clone https://github.com/marcinchabiera/sinatra-logger.git
    cd sinatra-logger
    bundle install
    
    nohup rackup -p 4567 -o 0.0.0.0 &
    tail -f nohup.out
    
    # fg    
    
## AWS instance USER DATA example
    #!/usr/bin/env bash
    yum -y update
    yum -y install httpd
    chkconfig httpd on
    service httpd start
    echo "<html><h1>Hello From Your Web Server!</h1></html>" > /var/www/html/index.html
    
    
## User data
    #!/bin/bash
    echo "USED DATA"
    echo $HOME
    export HOME=/home/ec2-user
    echo $HOME
    cd /home/ec2-user
    source .bashrc
    source .bash_profile
    export EC2_INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
    aws ec2 associate-address --instance-id $EC2_INSTANCE_ID --public-ip ${STATIC_PUBLIC_IP}
    cd sinatra-logger
    nohup rackup -p 4567 -o 0.0.0.0 &        