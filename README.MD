### Start app locally
    cd ./app
    bundle install
    bundle exec ruby app.rb
    open http://localhost:4567
    
### Build docket container
    ./build.sh

### Start app in docker container
    docker run -it --rm --name requests_logger \
            -p 4567:4567 \
            -v "$PWD":/usr/src \
            requests_logger:latest
    
### Examples

#### POST - SEND REQUEST
    [default response code: 201]
    curl --request POST --data '{"username":"xyz","password":"xyz"}' http://localhost:4567/REQ123 

#### POST - SEND REQUEST 
    [with forced response code XXX, use suffix -return-status-XXX in request id]
    curl --request POST --data '{"username":"xyz","password":"xyz"}' http://localhost:4567/REQ123-return-status-403 

#### GET - READ REQUEST
    curl http://localhost:4567/REQ123 

#### DELETE REQUEST
    curl -X DELETE http://localhost:4567/REQ123
     
    