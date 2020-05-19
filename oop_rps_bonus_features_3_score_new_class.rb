require 'pry-byebug'

class Move
  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def to_s
    @value
  end
end

class Rock < Move
  def initialize
    @value = "rock"
  end

  def rock_wins?(other_move)
    ((rock? && other_move.scissors?) ||
    (rock? && other_move.lizard?))
  end

  def rock_lost?(other_move)
    ((rock? && other_move.paper?) ||
    (rock? && other_move.spock?))
  end

  def >(other_move)
    rock_wins?(other_move)
  end

  def <(other_move)
    rock_lost?(other_move)
  end
end

class Paper < Move
  def initialize
    @value = "paper"
  end

  def paper_wins?(other_move)
    ((paper? && other_move.rock?) ||
    (paper? && other_move.spock?))
  end

  def paper_lost?(other_move)
    ((paper? && other_move.scissors?) ||
    (paper? && other_move.lizard?))
  end

  def >(other_move)
    paper_wins?(other_move)
  end

  def <(other_move)
    paper_lost?(other_move)
  end
end

class Scissors < Move
  def initialize
    @value = "scissors"
  end

  def scissors_wins?(other_move)
    ((scissors? && other_move.paper?) ||
    (scissors? && other_move.lizard?))
  end

  def scissors_lost?(other_move)
    ((scissors? && other_move.spock?) ||
    (scissors? && other_move.rock?))
  end

  def >(other_move)
    scissors_wins?(other_move)
  end

  def <(other_move)
    scissors_lost?(other_move)
  end
end

class Lizard < Move
  def initialize
    @value = "lizard"
  end

  def lizard_wins?(other_move)
    ((lizard? && other_move.spock?) ||
    (lizard? && other_move.paper?))
  end

  def lizard_lost?(other_move)
    ((lizard? && other_move.scissors?) ||
    (lizard? && other_move.rock?))
  end

  def >(other_move)
    lizard_wins?(other_move)
  end

  def <(other_move)
    lizard_lost?(other_move)
  end
end

class Spock < Move
  def initialize
    @value = "spock"
  end

  def spock_wins?(other_move)
    ((spock? && other_move.rock?) ||
    (spock? && other_move.scissors?))
  end

  def spock_lost?(other_move)
    ((spock? && other_move.paper?) ||
    (spock? && other_move.lizard?))
  end

  def >(other_move)
    spock_wins?(other_move)
  end

  def <(other_move)
    spock_lost?(other_move)
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp.capitalize
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if RPSGame::MOVES.keys.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = RPSGame::MOVES[choice]
  end
end

class Computer < Player
  def set_name
    self.name = ["Jarvus", "R2D2", "Chappie"].sample
  end

  def choose
    self.move = RPSGame::MOVES.values.sample
  end
end

class Score
  attr_accessor :human_score, :computer_score
  WINNING_POINTS = 2

  def initialize
    binding.pry
    @human_score = 0
    @computer_score = 0
  end

  def update_score(winner)
    binding.pry
    if winner
      if winner == "human"
        human_score += 1
      else
        computer_score += 1
      end
    end
  end

  def winner?
    human_score == WINNING_POINTS ||
    computer_score == WINNING_POINTS
  end

  def find_winner 
    if human_score > computer_score
      return "human"
    else
      return "computer"
    end
  end

  def reset_score
    human_score = 0
    computer_score = 0
  end
end


class RPSGame
  attr_accessor :human, :computer, :score

  MOVES = { "rock" => Rock.new, "paper" => Paper.new,
            "scissors" => Scissors.new, "lizard" => Lizard.new,
            "spock" => Spock.new }

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
  end

  def display_welcome_message
    puts "Hi #{human.name}!"
    puts ""
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!"
  end

  def display_moves
    puts ""
    puts "#{human.name} chose: #{human.move}"
    sleep 1
    puts "#{computer.name} chose: #{computer.move}"
  end

  def display_round_winner
    winner = 0
    puts ""
    sleep 2
    if human.move > computer.move
      winner = "human"
      puts "#{human.name} won this round!"
    elsif human.move < computer.move
      winner = "computer"
      puts "#{computer.name} won this round!"
    else
      puts "It's a tie!"
    end

    score.update_score(winner)    
  end

  def display_score
    sleep 1
    puts ""
    puts "The score is..."
    puts ""
    sleep 1
    puts "#{human.name}: #{score.human_score}"
    puts "#{computer.name}: #{score.computer_score}"
    puts ""
  end

  def grand_winner?
    score.winner?
  end

  def display_grand_winner
    winner = score.find_winner 
  
    sleep 1
    puts "#{winner} has won the game!"
    score.reset_score
  end

  def play_again?
    answer = nil

    loop do
      puts ""
      sleep 1
      puts "Would you like to play again? y or n"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n ."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_moves
      display_round_winner
      display_score
      display_grand_winner if grand_winner?
      break unless play_again?
      system 'clear'
    end

    display_goodbye_message
  end
end

RPSGame.new.play
