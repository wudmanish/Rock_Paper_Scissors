require 'sinatra'
set :bind, '0.0.0.0'
set :views, "views"

# before we process a route, we'll set the response as
# plain text and set up an array of viable moves that
# a player (an computer) can perform

before do 
    @defeat = {rock: :scissor, paper: :rock, scissors: :paper}
    @throws = @defeat.keys
end

get '/' do
    erb :start
end

get '/throw/:type' do
    # the params[] hash stores query string and form data.
    player_throw = params[:type].to_sym
    
    
    #in the case of a player providing a throw that is not valid
    #we halt with a status code 403 (Forbidden) and let them
    #know they need to make a valid throw to play.
    if !@throws.include?(player_throw)
        halt 403, "You must throw one of the following: #{@throws}"
    end
    
    #now we can select a random throw for the computer
    computer_throw = @throws.sample
    
    #compare the player and computer throws to determine a winner
    if player_throw == computer_throw
        erb :draw
        #"You tied with the computer. Try again!"
    elsif computer_throw == @defeat[player_throw]
        erb :win, :locals => {:computer_throw => computer_throw, :player_throw => player_throw}
        #"Nicely done; #{player_throw} beats #{computer_throw}"
    else
        erb :loss, :locals => {:computer_throw => computer_throw, :player_throw => player_throw}
        #"Ouch; #{computer_throw} beats #{player_throw}. Better luck next time!"
    end
end