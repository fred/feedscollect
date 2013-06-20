#!/bin/sh

git push heroku-web master &&
git push heroku-worker master &&
echo "done"
