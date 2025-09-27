# Devent-App

## Features

### Events

*Create events in Devent and share it via Discord.<br>
*Join events from the discord server.<br>
*Have a Bot that auto creates channels on event start and delete channels at event end.<br>
*Versus and standard event types. Versus events will have two team channel being created.<br>
*Extend discord with scheduled Events and extended social profile feature (tbd.)<br>
*Archive events to dwell on memories being created. Document events with attached media.
*Connect with other discord server communities who use Devent
*Connect events to a existing game which is verified by using the IGDB API

## Setup

Node: 22<br>
yarn: 1.22.22<br>
PostgresSQL: 16+<br>
Redis: 7 (Worker persists jobs here)

### Usefull links

https://discord.com/developers/applications/764062582310436875/information
<br>`Discord application that connects to various discord servers (Bot)`

https://github.com/idealistic91/blank_community
<br>`Project repository`

https://github.com/shardlab/discordrb
<br>`Discord API Client Gem`


# Worker
> Handles Jobs for creating, deleting channels and creating temporary discord roles.

## Install Redis

### Docker

Install docker on your machine and run the command below.

### Linux

`sudo apt-get install lsb-release curl gpg`

`curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg`

`sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg`

`echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list`

`sudo apt-get update`

`sudo apt-get install redis`

### Mac

Make sure you have homebrew installed. If not install it first: https://brew.sh/

`brew install redis`<br>

## Boot up redis

### Docker

`docker run --rm -p 6379:6379 redis:7`

### Linux
`sudo systemctl enable redis-server`

`sudo systemctl start redis-server`

### Mac
`brew services start redis`

# Web

Make sure you have a running postgresql server running at the default port.

### Install dependencies

> Navigate to the projects root directory.


**Install ruby gems**<br>
`bundle install`

**Install npm packages**<br>
`yarn install`

### Create the Database and migrate the tables

**Create the database**<br>
`rails db:create`

**Migrate the tables**<br>
`rails db:migrate`

### Compile the assets

**For one time compiling**<br>
`bin/webpack`

**Continuous compiling**<br>
`bin/webpack-dev-server`

> This is recommended in development. It listens to changes to your html, css and js files and recompiles on the fly.<br>
> Open a new tab for this so it runs beside your rails server

### Boot everything up

When you choose to use the `webpack-dev-server`we will have three tabs open in our terminal:

#### bin/rails server

#### bundle exec sidekiq

#### bin/webpack-dev-server

# First steps
> For now, we assume you have a Bot connected to your own discord server + created a application int 

## Discord server registration
> For this you need to be the owner of the discord server!

In a random discord channel type:

`register:server`

The Devent Bot will send you a link via dm that you can use to register the server and yourself.

## Single user registration
> This can be used by users on your discord server to get the registration link from our Bot.

`register:me`

The Bot will send the user an dm with the registration link inside.


## Create your first event

Navigate to `Events` from the navigation bar. Click "Erstellen". <br>
Fill out the form and hit "Event erstellen".
> Note: the event type "Versus" will create two discord channels for you  "Team 1" and "Team 2"

Your discord server will receive a message about the newly created event and other users can join via the message.
If they have registered themselves via `register:me` before.

## Discord interaction with events

There are several commands that you can use to display information about events.

>`events:me`
> Lists Events where you partipate

> `events:last`
> The last events being created

> `events:<id>`
> Look up an event by id