#!/bin/env ruby

require "debug"

module RockPaperScissor
  class Round
    attr_reader :choices

    def initialize(*hands)
      @choices = hands.map { |choice| WeaponFactory.arm(choice) }
    end

    def round_outcome_points(attacker, defender)
      if attacker.beats?(defender)
        6
      elsif attacker.ties?(defender)
        3
      else
        0
      end
    end

    # The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).
    def score
      choices.map.with_index do |choice, index|
        next_choice = choices[(index + 1) % choices.length]
        choice.points + round_outcome_points(choice, next_choice)
      end
    end
  end

  class WeaponFactory
    def self.arm(weapon)
      {
        "A" => Rock,
        "B" => Paper,
        "C" => Scissor,
        "X" => Rock,
        "Y" => Paper,
        "Z" => Scissor
      }[weapon].new
    end
  end

  class RPS
    def ties?(other) = other.instance_of?(self.class)

    def points = self.class::POINTS
  end

  class Rock < RPS
    POINTS = 1
    def beats?(other) = other.instance_of?(Scissor)
  end

  class Paper < RPS
    POINTS = 2
    def beats?(other) = other.instance_of?(Rock)
  end

  class Scissor < RPS
    POINTS = 3
    def beats?(other) = other.instance_of?(Paper)
  end
end

@input = File.readlines("input.txt").map { _1.split(/\s+/) }
require "debug"
require "pp"

@tally = @input.each_with_object([0, 0]) do |round_input, tally|
  round = RockPaperScissor::Round.new(round_input[0], round_input[1])

  round.score.each_with_index do |score, index|
    tally[index] += score
  end
end

pp @tally
