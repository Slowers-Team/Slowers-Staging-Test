/* eslint-disable react/prop-types */
import axios from 'axios'
import { useEffect, useState } from 'react'

const App = () => {
  const [books, setBooks] = useState([])
  const [newBookTitle, setNewBookTitle] = useState('')
  const [newBookAuthor, setNewBookAuthor] = useState('')

  useEffect(() => {
    console.log('effect')
    axios
      .get('/api/books')
      .then(response => {
        console.log('promise fulfilled')
        setBooks(response.data)
      })
  }, [])

  const addBook = event => {
    event.preventDefault()
    const bookObject = {
      title: newBookTitle,
      author: newBookAuthor
    }

    axios
      .post('/api/books', bookObject)
      .then(response => {
        console.log(response)
        setBooks(books.concat(response.data))
        setNewBookTitle('')
        setNewBookAuthor('')
      })
  }

  const handleBookTitleChange = (event) => {
    console.log(event.target.value)
    setNewBookTitle(event.target.value)
  }

  const handleBookAuthorChange = (event) => {
    console.log(event.target.value)
    setNewBookAuthor(event.target.value)
  }


  return (
    <div>
      <h1>Books</h1>
      <BookForm 
        event={addBook}
        title={newBookTitle}
        handleBookTitleChange={handleBookTitleChange}
        author={newBookAuthor}
        handleBookAuthorChange={handleBookAuthorChange}
      />
      {books && <BookList books={books} />}
    </div>
  )

}

const BookList = ({ books }) => {
  return (
    <div className="booklist">
      {books.map((book) => (
        <div className="book-view" key={book.id}>
          <h2>{ book.title }</h2>
          <p>Written by { book.author }</p>
        </div>
      ))}
    </div>
  )
}

const BookForm = ({ event, title, handleBookTitleChange, author, handleBookAuthorChange }) => {
  return (
    <div>
      <form onSubmit={event}>
        <div>
          title003: <input value={title} onChange={handleBookTitleChange} />
        </div>
        <div>
          author: <input value={author} onChange={handleBookAuthorChange}/>
        </div>
        <div>
          <button type='submit'>save</button>
        </div>
      </form>
    </div>
  )
}

export default App
