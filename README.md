# Anthology

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
* `DB_USERNAME` - _(optional)_ Defaults to "books" if this is not set.
* `DB_PASSWORD` - _(optional)_
* `DB_HOST` - _(optional)_
* `DB_PORT` - _(optional)_

### Setting up the Google Client ID and Google Client Secret
To set up the Google authentication, you will need to get a `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` by visiting the [Google API console](https://code.google.com/apis/console/)
and choosing the option to create an "OAuth Client ID". You should select 'Web application' as the application type and enter `<site-address>/auth/google/callback` as the "authorised
redirect URI". No additional OAuth 2.0 scopes need to be added.

## CI setup

CI runs using GitHub Actions

## Licence

Anthology is released under the [MIT Licence](http://www.opensource.org/licenses/MIT).
