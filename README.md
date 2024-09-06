# README

# Dependencies:

- RVM
  `> brew install rvm`
- Ruby
  `> rvm install ruby`
- Rails
  `sudo gem install rails`
- Postgres
  `brew install postgres`

# Instructions

# Troubleshooting

If you see this error:

```
Couldn't create 'buildings_platform_development' database. Please check your configuration.
bin/rails aborted!
ActiveRecord::ConnectionNotEstablished: connection to server on socket "/tmp/.s.PGSQL.5432" failed: No such file or directory (ActiveRecord::ConnectionNotEstablished)
```

Try running this:

```
> rm /usr/local/var/postgres/postmaster.pid
> brew services restart postgresql
```
