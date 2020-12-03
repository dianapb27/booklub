class BookApiFetcher
  include Executable
  include ActionView::Helpers::SanitizeHelper

  def initialize(id_value)
    @book_id = id_value
    @url = "https://books.googleapis.com/books/v1/volumes/#{@book_id}?key=#{ENV['GOOGLE_API_KEY']}"
  end

  def execute
    google_serialized   = open(@url).read
    google              = JSON.parse(google_serialized)

    
    authors             = google['volumeInfo']['authors']
    title               = google['volumeInfo']['title']
    description         = google['volumeInfo']['description']
    page_count          = google['volumeInfo']['pageCount']
    categories          = google['volumeInfo']['categories']
    unless categories.nil?
      categories = categories.join(', ')
      categories = categories.gsub(' / ', ', ')
      # categories = categories.gsub('Fiction, ', '')
      # categories = categories.gsub('General, ', '')
    end
    avg_rating          = google['volumeInfo']['avgRating']
    image               = google['volumeInfo']['imageLinks']['thumbnail']
    image_lg            = google['volumeInfo']['imageLinks']['large']
    image_md            = google['volumeInfo']['imageLinks']['medium']
    image_sm            = google['volumeInfo']['imageLinks']['small']
    {
      authors: authors,
      title: title,
      description: strip_tags(description), 
      page_count: page_count,
      categories: categories,
      avg_rating: avg_rating,
      image_sm: image_sm,
      image_md: image_md,
      image_lg: image_lg,
      image: image
    }
  end
end

#  @book = BookApiFetcher.execute(value)