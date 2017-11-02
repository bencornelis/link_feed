## Monsters

Link aggregator site based loosely on [Hacker News](https://news.ycombinator.com/) and [hubski](https://hubski.com/).

https://blooming-mesa-35436.herokuapp.com/

Login
* username: `testuser`
* password: `foobar`

### Features

* CRUD operations on posts and comments
* posts can be ranked by score or time
* comments are ranked by score
* posts are tagged with multiple tags and can be filtered by tag
* users can follow and unfollow other users
* users can share posts and comments with followers
* user feed consisting of posts that have been shared by a user's followees
* users are assigned badges after receiving shares and can badge posts and comments
* user statistics on user profile

### About

My goal with this project was to learn more about Active Record associations and experiment with some rails design patterns. It uses:

* RSpec, Capybara, and Factory Girl for testing
* user authentication with devise
* user authorization with pundit
* user roles with rolify
* ancestry for nested comments
* goldiloader for automatic eager loading
* pagination with will_paginate
* presenter design pattern for views
* Hacker News formula for post and comment ranking
* Faker data for database seeding
* Select2 jQuery select box for autocompleting tags via AJAX
* jQuery modals for displaying views with AJAX

### Setup

To get started run:
* `bundle`
* `rake db:create`
* `rake db:migrate`

To run the tests:
* `rake db:test:prepare`
* `rspec`

To seed the database with some users, relationships, posts and comments, run `rake db:seed`.

To explore the app without having to sign up and email confirm, feel free to use the login:
* username: `testuser`
* password: `foobar`
