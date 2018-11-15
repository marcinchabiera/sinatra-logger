FROM ruby:2.5

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ./Gemfile /usr/src/app/
#COPY ./app/entrypoint.sh /usr/src/app/

RUN bundle install
#RUN chmod +x /usr/src/app/entrypoint.sh
#ENTRYPOINT /usr/src/app/entrypoint.sh
EXPOSE 4567
#ENTRYPOINT ["bundle", "exec", "ruby", "app.rb"]