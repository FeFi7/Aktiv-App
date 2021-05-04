# pull the Node.js Docker image
FROM node:alpine

# create the directory inside the container
WORKDIR /usr/src/app

# copy the package.json files from local machine to the workdir in container
COPY package*.json ./

# run npm install in our local machine
RUN npm install

# copy the generated modules and all other files to the container
COPY . .

# our app is running on port 3000 - 3003 within the container, so need to expose it
EXPOSE 3000
EXPOSE 3001
EXPOSE 3002
EXPOSE 3003

# the command that starts our app
CMD ["node", "app.js"]