rails db:drop
rails db:create
heroku pg:backups capture --app sapsb
curl -o latest.dump `heroku pg:backups public-url --app sapsb`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d sapsb_development latest.dump
rails db:migrate
rm latest.dump
