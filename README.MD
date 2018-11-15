## Locally
    cd app
    bundle exec ruby app.rb
    http://localhost:4567

docker run -it --rm --name my-running-script \
    -v "$PWD":/usr/src/app -w /usr/src/app requests_logger bash -c 'ls -al'
    