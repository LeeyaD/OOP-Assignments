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

class RPSGame
  attr_accessor :human, :computer

  MOVES = { "rock" => Rock.new, "paper" => Paper.new,
            "scissors" => Scissors.new, "lizard" => Lizard.new,
            "spock" => Spock.new }

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose: #{human.move}"
    puts "#{computer.name} chose: #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "Its a tie!"
    end
  end

  def play_again?
    answer = nil

    loop do
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
      display_winner
      break unless play_again?
    end

    display_goodbye_message
  end
end

RPSGame.new.play
