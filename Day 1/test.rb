require 'json'

class Book
  attr_accessor :title, :authen, :isbn

  def initialize(title, authen, isbn)
    @title = title
    @authen = authen
    @isbn = isbn
  end

  def to_hash
    { title: @title, authen: @authen, isbn: @isbn }
  end
end

class Inventory
  def initialize(file_path)
    @file_path = file_path
    load_books()
  end

  def list_books()
    @books.each do |book|
      puts "Book Title: #{book.title}, Author: #{book.authen}, ISBN: #{book.isbn}"
    end
  end

  def add_book(title, authen, isbn)
    unless @books.any? { |book| book.isbn == isbn }
      @books << Book.new(title, authen, isbn)
      save_books()
      puts "Book added successfully."
    else
      puts "Book with same ISBN already exists."
    end
  end

  def remove_book(isbn)
    initial_book_count = @books.length
    @books.reject! { |book| book.isbn == isbn }
    if @books.length < initial_book_count
      save_books()
      puts "Book removed successfully."
    else
      puts "No book found with the provided ISBN."
    end
  end

  private
  def load_books()
    @books = []
    if File.exist?(@file_path)
      data = File.read(@file_path)
      @books = JSON.parse(data).map { |book| Book.new(book['title'], book['authen'], book['isbn']) }
    end
  end

  def save_books()
    File.open(@file_path, 'w') do |file|
      file.write(JSON.generate(@books.map(&:to_hash)))
    end
  end
end

def menu
  puts "\nMenu:"
  puts "1. List Books"
  puts "2. Add New Book"
  puts "3. Remove Book by ISBN"
  puts "4. Exit"
end

def list_books(inventory)
  puts "\nList of books:"
  inventory.list_books()
end

def add_book(inventory)
  print "\nEnter the title of the book: "
  title = gets.chomp
  print "Enter the author of the book: "
  authen = gets.chomp
  print "Enter the ISBN of the book: "
  isbn = gets.chomp
  inventory.add_book(title, authen, isbn)
end

def remove_book(inventory)
  print "\nEnter the ISBN of the book to remove: "
  isbn = gets.chomp
  inventory.remove_book(isbn)
end

inventory = Inventory.new('books.json')

loop do
  menu
  print "\nEnter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    list_books(inventory)
  when 2
    add_book(inventory)
  when 3
    remove_book(inventory)
  when 4
    puts "\nExiting..."
    break
  else
    puts "\nInvalid choice! Please enter a number from the menu."
  end
end
