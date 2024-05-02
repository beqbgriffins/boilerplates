# README

To start the application:

### Install dependencies

```bash
bundle install
```

### Create and migrate the database

```bash
rails db:create db:migrate db:seed
```

### add jwt secret key to rails credentials

```bash
EDITOR="nano --wait" rails credentials:edit
```

Add the following to the credentials file:

```yaml
jwt_secret: "your_secret_key"
```