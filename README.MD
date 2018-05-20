## Locally
    rackup -p 4567
    http://localhost:4567

## AWS
    sudo yum update
    gem install bundle
    yum install git 
    git clone 
    bundle install
    rackup -p 4567 -o 0.0.0.0    
    
## AWS instance USER DATA example
    #!/bin/bash
    yum -y update
    yum -y install httpd
    chkconfig httpd on
    service httpd start
    echo "<html><h1>Hello From Your Web Server!</h1></html>" > /var/www/html/index.html