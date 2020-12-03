class BooksApiFetcher
  include Executable

  def initialize(book_query)
    @book_query = book_query.gsub(" ", "+")
    @url = "https://www.goodreads.com/search/index.xml?key=#{ENV['GOODREADS_API_KEY']}&q="
  end

  def execute
    search = @url + @book_query
    doc = Nokogiri::XML(URI.open(search)) 
    book = doc.xpath('//best_book')[0...8].map do |best_book|  
      author              = best_book.search('name').text.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
      title               = best_book.search('title').text.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
      book_title          = title.gsub(" ", "%20")
      book_author         = author.gsub(" ", "%20")
      google_url          = "https://www.googleapis.com/books/v1/volumes?q=#{book_title}%20#{book_author}&key=#{ENV['GOOGLE_API_KEY']}"
      document_serialized = open(google_url).read
      document            = JSON.parse(document_serialized)
      book_id             = document['items'][0]['id']
      if document['items'][0]['volumeInfo']['imageLinks'].nil?
        image_url         = best_book.search('image_url').text
      else
        image_url         = document['items'][0]['volumeInfo']['imageLinks']['thumbnail']
      end
      # book_id = best_book.at_xpath('id').text
      # book_id             = best_book.at_xpath('id').text
       { author: author, title: title, image_url: image_url, book_id: book_id }
    end
    # raise
  end
end




