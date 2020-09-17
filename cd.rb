require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  db = SQLite3::Database.new 'db_words.db'
  db.results_as_hash = true
  return db
end

configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS
"words"
( "id" INTEGER,
   "words_rus" TEXT,
    "words_en" TEXT,
     PRIMARY KEY("id" AUTOINCREMENT)
     )'
end

get '/'do
def main_menu

  puts "Команды:\n  'Enter' - начать игру;\n
  '+' - добавить слово и перевод в базу;\n
  '++' - добавить перевод слова, к уже имеющемся в базе;\n
  '-' - удалить слово и перевод из базы;\n
  '+-' - редактировать слово и перевод;\n
  '//' - произвести сортировку базы данных;\n
  '!!' - выйти из приложения.\n"
  puts @qq

  print 'Введите команду: '
  command = gets.strip
  puts @qq

  case
  when command == '' # начать игру
    launch_game
  when command == '+' # добавить слово и перевод в базу
    add_new_word_in_base_words
  when command == '++' # добавить перевод слова, к уже имеющемся в базе
    add_translate_word
  when command == '-' # удалить слово и перевод из базы
    delete_word
  when command == '+-' # редактировать слово и перевод
    editing_words
  when command == '//' # Произвести сортировку базы данных
    sorting_base_words
  when command == '!!' # выйти из приложения
    exit
  else
    puts "Введённая команда: '#{command}' не идентифицированна"
    puts "Пожайлуйста повторите команду снова."
    puts @qq
    main_menu
  end
end
  erb :home
end

get '/game' do
  erb :game
end

get '/add_words' do
  erb :add_words
end

get '/add_translation' do
  erb :add_translation
end

get '/edit_the_words' do
  erb :edit_the_words
end

get '/remove_the_word' do
  erb :remove_the_word
end

get '/show_words' do
  erb :show_words
end

post '/home' do

  @words_rus = params[:words_rus]
  @words_en = params[:words_en]

  hh = { words_rus: 'Введите слово или предложение (rus)', words_en:
        'Введите перевод (en)', }

  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :home
  end
db = get_db
db.execute 'INSERT INTO
  words
   (
    words_rus,
     words_en
      )
  values (?, ?)', [@words_rus, @words_en]

  erb :home

end

post '/add_words' do
  db = get_db
reault = db.query 'SELECT words_rus, words_en FROM
  words
  WHERE words_rus=?', [@words_rus]
  erb :add_words
end
