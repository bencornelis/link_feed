## Monsters

Link aggregator site based loosely on [Hacker News](https://news.ycombinator.com/) and [hubski](https://hubski.com/).

https://blooming-mesa-35436.herokuapp.com/

### Features

* CRUD operations on posts and comments
* posts can be ranked by score or time
* posts are tagged with multiple tags and can be filtered by tag
* users can follow other users
* users can share posts with followers
* user feed consisting of posts that have been shared by a user's followees

### About

My goal with this project was to learn more about active record associations and experiment with some rails design patterns. It uses:

* RSpec, Capybara, and Factory Girl for testing
* user authentication with bcrypt
* user authorization with pundit
* user roles with rolify
* ancestry for nested comments
* goldiloader for automatic eager loading
* pagination with will_paginate
* presenter design pattern for views
* Hacker News formula for post ranking
* faker data for database seeding

### Setup

To get started run:
* `bundle`
* `rake db:create`
* `rake db:migrate`

To run the tests:
* `rake db:test:prepare`
* `rspec`

To seed the database with some users, relationships, posts and comments, run `rake db:seed`.
