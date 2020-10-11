**Setup docker container**

1. Install docker for your OS
2. git clone this repository
3. cd marketingtool-backend
4. execute docker-compose build (this can take a while)
5. execute docker-compose up
6. Create database: docker-compose run web rake db:create
7. The rails server and database should be running now
8. To enter rails commands you have to execute docker-compose run web <RAILS COMMANDS>
   (eg.: docker-compose run web rails console, docker-compose run web rails generate model User name:string)
   This will boot up an instance every time... 
   You can also enter cli via the docker dashboard which connects you with the linux cli, this instance stays up till you exit it
   
**Changes to the Gemfile and Dockerfile**
If you change something in these files you have to docker-compose build again! Before you do that
execute docker-compose down
