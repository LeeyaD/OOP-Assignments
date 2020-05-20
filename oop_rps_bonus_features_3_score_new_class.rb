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
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = Score.new
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
  attr_accessor :points

  def initialize
    @points = 0
  end

  def update
    self.points += 1
  end

  def reset
    self.points = 0
  end

  def to_s
    "#{points}"
  end
end

class RPSGame
  attr_accessor :human, :computer, :scoreboard

  MOVES = { "rock" => Rock.new, "paper" => Paper.new,
            "scissors" => Scissors.new, "lizard" => Lizard.new,
            "spock" => Spock.new }

  WINNING_POINTS = 2

  def initialize
    @human = Human.new
    @computer = Computer.new
    @scoreboard = { human.name => human.score,
                    computer.name => computer.score }
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

  def human_won?
    human.move > computer.move
  end

  def computer_won?
    human.move < computer.move
  end

  def tie?
    !human_won? && !computer_won?
  end

  def display_round_winner
    puts ""
    sleep 2
    if human_won?
      winner = human
    elsif computer_won?
      winner = computer
    elsif tie?
      puts "It's a tie!"
    end

    puts "#{winner.name} won this round!" if winner
    winner.score.update if winner
  end

  def display_score
    sleep 1
    puts ""
    puts "The score is..."
    puts ""
    sleep 1
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    puts ""
  end

  def grand_winner?
    scoreboard.values.any? do |score|
      score.points == WINNING_POINTS
    end
  end

  def find_grand_winner
    winner = scoreboard.select do |_, score|
      score.points == WINNING_POINTS
    end

    winner.keys[0]
  end

  def display_grand_winner
    sleep 1
    if grand_winner?
      puts "#{find_grand_winner} has won the game!"
    end

    human.score.reset
    computer.score.reset
  end

  def play_again?
    answer = nil

    loop do
      puts ""
      puts "Would you like to play again? y or n"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n ."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def players_choose_moves
    human.choose
    computer.choose
  end

  def play
    display_welcome_message

    loop do
      players_choose_moves
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
#bonus feature keeping pionts should be TEN POINTS!
