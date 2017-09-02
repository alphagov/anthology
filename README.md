# Anthology [![Build Status](https://travis-ci.org/JordanHatch/anthology.png?branch=master)](https://travis-ci.org/JordanHatch/anthology)

An easier way to keep track of the books on your office bookshelf.

* Uses Google authentication
* Keeps track of multiple copies of each book
* Looks up book details from Google Books and Openlibrary based on the ISBN

![](http://jordanhatch.github.com/anthology/img/screenshot.png)

## Getting started

    bundle install
    bundle exec puma -p 5000

If you're in the development or test environments, OmniAuth's developer strategy is available, and selected by default. This allows you to authenticate without using Google by providing details for a stub user. If configuration for Google is present, Anthology will default to using authentication with Google instead.

## Configuration

The app is configured with a collection of environment variables:

* `LIBRARY_TITLE` - _(optional)_ name of the library, displayed throughout the app. This will default to "Library" if
this is not set.
* `GOOGLE_CLIENT_ID`
* `GOOGLE_CLIENT_SECRET`
* `RAILS_SECRET_TOKEN`
* `PERMITTED_EMAIL_HOSTNAMES` - the hostname(s) that are allowed to log in to the app
* `REQUEST_IP` - _(required for Heroku only)_ IP address to provide as the requester in calls to the Google Books API
* `DB_USERNAME` - _(optional)_ Defaults to "books" if this is not set.
* `DB_PASSWORD` - _(optional)_
* `DB_HOST` - _(optional)_
* `DB_PORT` - _(optional)_

### Setting up the Google Client ID and Google Client Secret
To get a working `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`, you will need to log in to the Google API console and
choose the option to create an "OAuth Client ID". This should have the `Google+ API` and `Contacts API` permissions
enabled.

The "authorised redirect URI" to use is `<address-where-site-will-be-hosted>/auth/google/callback`

## CI setup

CI runs using Travis.

## Licence

Anthology is released under the [MIT Licence](http://www.opensource.org/licenses/MIT).
