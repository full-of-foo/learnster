
## Learnster - An Open Source Learning Management System

Currently in development, learnster is a pure single page app learnining management system, with a Backbone.Marionette front-end backed by a Rails API


### System Requirements

 - rails 4.0.1
 - ruby 2+
 - bundler

### Development Bootstrapping

 - bundle install
 - rake db:migrate
 - rake db:seed
 - GMAIL_USERNAME='foo@bar.com' GMAIL_PASSWORD='pass' rake start
 - GMAIL_USERNAME='foo@bar.com' GMAIL_PASSWORD='pass' bin/delayed_job start

### Regression Testing

 - rake db:seed && SUT=myip.com KILL_ON_EXIT=1 HEADLESS=1 bundle exec cucumber




