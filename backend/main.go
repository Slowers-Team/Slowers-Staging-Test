package main

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Book struct {
	ID        primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	Title     string             `json:"title"`
	Author    string             `json:"author"`
	Completed bool               `json:"completed"`
}

var collection *mongo.Collection

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	mongoURI := os.Getenv("MONGODB_URI")
	if mongoURI == "" {
		log.Fatal("Set your 'MONGODB_URI' environment variable. " +
			"See: " +
			"www.mongodb.com/docs/drivers/go/current/usage-examples/#environment-variable")
	}
	clientOptions := options.Client().ApplyURI(mongoURI).SetTimeout(10*time.Second)
	client, err := mongo.Connect(context.Background(), clientOptions)
	if err != nil {
		panic(err)
	}

	defer func() {
		if err := client.Disconnect(context.Background()); err != nil {
			panic(err)
		}
	}()

	if err := client.Ping(context.Background(), nil); err != nil {
		panic(err)
	}

	log.Println("Connected to MongoDB003")

	collection = client.Database("library").Collection("books")

	app := fiber.New()

	app.Use(cors.New())

	app.Get("/api/books", getBooks)
	app.Post("/api/books", addBook)
	app.Patch("/api/books/:id", setBookStatusToCompleted)
	app.Delete("/api/books/:id", deleteBook)

	port := os.Getenv("PORT")
	if port == "" {
		port = "5001"
	}

	app.Static("/", "./client/dist")

	log.Fatal(app.Listen("0.0.0.0:" + port))
}

func getBooks(c *fiber.Ctx) error {
	cursor, err := collection.Find(c.Context(), bson.M{})
	if err != nil {
		return c.Status(500).SendString(err.Error())
	}

	var books []Book
	if err := cursor.All(c.Context(), &books); err != nil {
		return c.Status(500).SendString(err.Error())
	}

	return c.JSON(books)
}

func addBook(c *fiber.Ctx) error {
	book := new(Book)

	if err := c.BodyParser(book); err != nil {
		return c.Status(400).SendString(err.Error())
	}

	if book.Title == "" {
		return c.Status(400).SendString("Book title cannot be empty")
	}

	insertResult, err := collection.InsertOne(c.Context(), book)
	if err != nil {
		return c.Status(500).SendString(err.Error())
	}

	filter := bson.M{"_id": insertResult.InsertedID}
	createdRecord := collection.FindOne(c.Context(), filter)

	createdBook := &Book{}
	createdRecord.Decode(createdBook)

	return c.Status(201).JSON(createdBook)
}

func setBookStatusToCompleted(c *fiber.Ctx) error {
	id := c.Params("id")
	objectID, err := primitive.ObjectIDFromHex(id)

	if err != nil {
		return c.SendStatus(400)
	}

	filter := bson.M{"_id": objectID}
	update := bson.M{"$set": bson.M{"completed": true}}

	_, err = collection.UpdateOne(c.Context(), filter, update)
	if err != nil {
		return c.SendStatus(500)
	}

	return c.SendStatus(200)

}

func deleteBook(c *fiber.Ctx) error {
	id := c.Params("id")
	objectID, err := primitive.ObjectIDFromHex(id)

	if err != nil {
		return c.SendStatus(400)
	}

	filter := bson.M{"_id": objectID}
	result, err := collection.DeleteOne(c.Context(), filter)

	if err != nil {
		return c.SendStatus(500)
	}

	if result.DeletedCount < 1 {
		return c.SendStatus(404)
	}

	return c.SendStatus(204)
}
