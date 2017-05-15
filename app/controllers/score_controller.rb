class ScoreController < ApplicationController
  def display
    run_game(params[:attempt], params[:grid], params[:start], Time.new.hour * 60 + Time.new.min)
  end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  @result = { score: 0, translation: nil, time: 0, message: "" }
  if check_is_english(attempt) && check_in_the_grid(attempt, grid)
    @result[:score] = calculate_score(attempt, start_time, end_time)
    @result[:translation] = translation(attempt)
    @result[:time] = end_time - start_time.to_i
    fail
  end
  @result[:message] = message(attempt, grid)
  @result
end

def translation(word)
  url1 = "https://api-platform.systran.net/translation/text/translate?source=en&"
  url2 = url1 + "target=fr&key=443d0673-c483-4d70-93dc-f157e306f09f&input=#{word}"
  h = JSON.parse(open(url2).read)
  h["outputs"][0]["output"]
end

def check_is_english(word)
  translation(word) == word ? false : true
end

def check_in_the_grid(word, grid)
  # check if the attempt uses the same letters as ones in the grid
  h = o_to_h_with_count(word.upcase)
  h1 = o_to_h_with_count(grid)
  i = 0
  h.each do |k, v|
    h1.key?(k) && v <= h1[k] ? i += 1 : 0
  end
  i == word.size ? true : false
end

def o_to_h_with_count(word)
  word = word.join if word.class == Array
  j = word.scan(/\w/)
  h = {}
  j.each { |x| h[x] = word.count(x) }
  h
end

def calculate_score(word, start_time, end_time)
  word.length * 100 / (end_time - start_time.to_i)
end

def message(attempt, grid)
  message = "not an english word" unless check_is_english(attempt)
  message = "not in the grid" unless check_in_the_grid(attempt, grid)
  message = "well done" if check_is_english(attempt) && check_in_the_grid(attempt, grid)
  message
end

end
