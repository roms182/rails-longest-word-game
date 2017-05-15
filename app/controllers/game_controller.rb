class GameController < ApplicationController

def welcome
  @grid = generate_grid
  @start = Time.new.hour * 60 + Time.new.min
end

def generate_grid
  # TODO: generate random grid of letters
 Array.new(9) { ("A".."Z").to_a.sample(1) }
end

end
