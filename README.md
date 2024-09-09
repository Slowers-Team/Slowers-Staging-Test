# Example-App

## Starting the application locally

1. Install and start MongoDB ([See MongoDB documentation for details](https://www.mongodb.com/docs/manual/administration/install-community))
2. Inside the `frontend` directory, install the dependencies and build the frontend using the commands
```
npm install
npm run build
```
3. Move the `frontend/dist` directory to `backend/client` (If the directory `backend/client` does not exist yet create it now)
4. Inside the `backend` directory, create `.env` file with the `ENV` and `MONGODB_URI` environment variables set as below (MongoDB URI might vary depending on your configuration)
```
ENV=production
MONGODB_URI=mongodb://localhost:27017
```
5. Inside the `backend` directory, start the app with the command `go run main.go`
6. Now the application is running at http://localhost:5001. It can be stopped by pressing Ctrl+C in the terminal where it was started.
7. The database is by default empty, so initially the application will show just an empty page. A new book can be added by opening the MongoDB shell with the command `mongosh library` and then using the `db.books.insertOne()` method (e.g. `db.books.insertOne({title: "The Lord of the Rings", author: "J. R. R. Tolkien", completed: true})`).
