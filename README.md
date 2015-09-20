## LinkFeed

Link aggregator/community forum based loosely on [hubski](https://hubski.com/).

### Features

* CRUD operations on posts and comments
* posts can be filtered by time, shares, or tags
* users can follow other users
* users can share posts with followers
* user feed consisting of posts that have been shared or posted by their followees.

### About

My goal with this project was to build my understanding of active record associations and experiment with some rails design patterns. It uses:

* user authentication with bcrypt
* user authorization with pundit
* user roles with rolify
* presenter design pattern for views

### Setup

To get started run:
* `bundle`
* rake db:create
* rake db:migrate

To run the tests:
* rake db:test:prepare
* rspec

To seed the database with some users, relationships, posts and comments, run `rake db:seed`.
