# Anthology [![Build Status](https://travis-ci.org/JordanHatch/anthology.png?branch=master)](https://travis-ci.org/JordanHatch/anthology)

An easier way to keep track of the books on your office bookshelf.

![](http://jordanhatch.github.com/anthology/img/screenshot.png)

## Configuration

The app is configured by a collection of environment variables:

* `GITHUB_CLIENT_ID`
* `GITHUB_CLIENT_SECRET`
* `GITHUB_ORG` - organisation username to restrict access
* `REQUEST_IP` - IP address to provide as the requester in calls to the Google Books API (required for Heroku)
* `LIBRARY_TITLE` - name of the library, displayed throughout the app
* `rails_secret_token`
