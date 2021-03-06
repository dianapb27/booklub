class BooksApiFetcher
  include Executable

  def initialize(book_query)
    @book_query = book_query
    normalize_query = @book_query.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
    @book_query = normalize_query.gsub(" ", "+")
    @url = "https://www.goodreads.com/search/index.xml?key=#{ENV['GOODREADS_API_KEY']}&q="
  end

  def execute
    search = @url + @book_query
    doc = Nokogiri::XML(URI.open(search)) 
    book = doc.xpath('//best_book').map do |best_book|  
      author                = best_book.search('name').text
      title                 = best_book.search('title').text
      # book_title          = title.gsub(" ", "%20")
      # book_author         = author.gsub(" ", "%20")
      # google_url          = "https://www.googleapis.com/books/v1/volumes?q=#{book_title}%20#{book_author}&langRestrict=en&key=#{ENV['GOOGLE_API_KEY']}"
      # document_serialized = open(google_url).read
      # document            = JSON.parse(document_serialized)
      # image_url           = document['items'][0]['volumeInfo']['imageLinks']['thumbnail']
      image_url             = best_book.at('image_url').content
      book_id               = best_book.at('id').content
      # book_id             = document['items'][0]['id']
      # book_id             = best_book.at_xpath('id').text
      { author: author, title: title, image_url: image_url, book_id: book_id }
    end
  end
end




