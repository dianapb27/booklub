class BooksApiFetcher
  include Executable

  def initialize(book_query)
    @book_query = book_query.gsub("'", "%27")
    query = @book_query.gsub(" ", "%20")
    @url = "https://books.googleapis.com/books/v1/volumes?q=#{query}&langRestrict=en&orderBy=relevance&key=#{ENV['GOOGLE_API_KEY']}"
  end

  def execute
    google_serialized   = open(@url).read
    google              = JSON.parse(google_serialized)

    items               = google['items'][0...10].map do |item|
      title             = item['volumeInfo']['title']
      authors           = item['volumeInfo']['authors']
      book_id           = item['id']
      if item['volumeInfo']['imageLinks'].nil?
        image_url = "booklub.jpg"
      else
        image_url         = item['volumeInfo']['imageLinks']['thumbnail']
      end

      { authors: authors, title: title, image_url: image_url, book_id: book_id }
    end

    # book = doc.xpath('//best_book')[0...8].map do |best_book|  
    #   author              = best_book.search('name').text.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
    #   title               = best_book.search('title').text.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
    #   book_title          = title.gsub(" ", "%20")
    #   book_author         = author.gsub(" ", "%20")
    #   google_url          = "https://www.googleapis.com/books/v1/volumes?q=#{book_title}%20#{book_author}&key=#{ENV['GOOGLE_API_KEY']}"
    #   document_serialized = open(google_url).read
    #   document            = JSON.parse(document_serialized)
    #   book_id             = document['items'][0]['id']
    #   if document['items'][0]['volumeInfo']['imageLinks'].nil?
    #     image_url         = best_book.search('image_url').text
    #   else
    #     image_url         = document['items'][0]['volumeInfo']['imageLinks']['thumbnail']
    #   end
    #   # book_id = best_book.at_xpath('id').text
    #   # book_id             = best_book.at_xpath('id').text
    #    { author: author, title: title, image_url: image_url, book_id: book_id }
    # end
  end
end




