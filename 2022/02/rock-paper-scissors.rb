#!/bin/env ruby

require "debug"

module RockPaperScissor
  class Round
    attr_reader :choices

    def initialize(hand_a, target_outcome)
      weapon_a = WeaponFactory.arm(hand_a)
      weapon_b = WeaponForOutcomeFactory.arm(target_outcome, target_weapon: weapon_a)
      @choices = [weapon_a, weapon_b]
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

  class RPS
    def ties?(other) = other.instance_of?(self.class)

    def points = self.class::POINTS
  end

  class Rock < RPS
    POINTS = 1

    def beats?(other) = other.instance_of?(Scissor)

    def beats = Scissor

    def ties = self.class

    def loses = Paper
  end

  class Paper < RPS
    POINTS = 2
    def beats?(other) = other.instance_of?(Rock)

    def beats = Rock

    def ties = self.class

    def loses = Scissor
  end

  class Scissor < RPS
    POINTS = 3
    def beats?(other) = other.instance_of?(Paper)

    def beats = Paper

    def ties = self.class

    def loses = Rock
  end

  class WeaponForOutcomeFactory
    def self.arm(outcome, target_weapon:)
      case outcome
      when "X" then target_weapon.beats.new
      when "Y" then target_weapon.ties.new
      when "Z" then target_weapon.loses.new
      end
    end
  end

  class WeaponFactory
    WEAPONS = {
      "A" => RockPaperScissor::Rock,
      "B" => RockPaperScissor::Paper,
      "C" => RockPaperScissor::Scissor
    }.freeze

    def self.arm(weapon)
      WEAPONS[weapon].new
    end
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
