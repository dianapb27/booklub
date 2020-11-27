class BookIdApiFetcher
  include Executable

  def initialize(id_value)
    @book_id = id_value
    @url = "https://www.goodreads.com/book/show/#{@book_id}.xml?key=#{ENV['GOODREADS_API_KEY']}&q="
  end

  def execute
    doc = Nokogiri::HTML(URI.open(@url))
    description = doc.search('description').first.text
    full_description = description[0, description.length - 3]
    image_url = doc.search('image_url').text
    author = doc.search('name').first.text
    title = doc.at_xpath('//original_title').text
    isbn = doc.search('isbn').text

    book_title = title.delete(" ")
    google_url = "https://www.googleapis.com/books/v1/volumes?q=#{book_title}&langRestrict=en"
    document_serialized = open(google_url).read
    document = JSON.parse(document_serialized)
    google_id = document['items'][0]['id']
    google_id_url = "https://www.googleapis.com/books/v1/volumes/#{google_id}?key=#{ENV['GOOGLE_API_KEY']}"
    google_document_serialized = open(google_id_url).read
    google_doc = JSON.parse(google_document_serialized)
    sm_thumbnail = google_doc['volumeInfo']['imageLinks']['smallThumbnail']
    thumbnail = google_doc['volumeInfo']['imageLinks']['thumbnail']

    { description: full_description, thumbnail: thumbnail, sm_thumbnail: sm_thumbnail, author: author, isbn: isbn, title: title }
  end
end

#  @books = BookIdApiFetcher.execute(value)
