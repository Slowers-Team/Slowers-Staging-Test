import { useEffect, useState } from 'react'
import axios from 'axios'

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

const App = () => {
  const [books, setBooks] = useState(null)

  useEffect(() => {
    axios
      .get('/api/books')
      .then(response => setBooks(response.data))
  }, [])

  return (
    <div>
      {books && <BookList books={books} />}
    </div>
  )

}

export default App
