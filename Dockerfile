#your baseImage
FROM alpine:latest

#install bash in your image
RUN apk add bash

#add user group and ass user to that group
RUN addgroup -S cron-group && adduser -S cron-user -G cron-group

#creates work dir
WORKDIR /app

#copy shell script to the container folder app
COPY myscript.sh /app/myscript.sh
RUN chmod +x /app/myscript.sh

#user is cron-user
USER cron-user
CMD ["/app/myscript.sh"]