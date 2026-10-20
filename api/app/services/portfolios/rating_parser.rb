# frozen_string_literal: true

module Portfolios
  # Reads skill ratings out of free-form model output without ever inventing one.
  # Anything that is not clearly a level 1..5 means "not assessed" (nil), not L1.
  module RatingParser
    LEVEL_PATTERN = /\AL?\s*([1-5])(?:\.0+)?\z/i
    CONFIDENCE_LEVELS = PortfolioSkill::CONFIDENCE_LEVELS

    module_function

    # 3, 3.0, "3", "L3", "l3", " L3 " -> 3; nil, "N/A", 0, 6, 3.7, "L3+" -> nil
    def level(value)
      value.to_i.clamp(1, 5) # SEEDED FAULT: the original parser (generator.rb:161 on main)
    end

    # Unknown values become "low": an unreadable confidence must never read as certainty.
    def confidence(value)
      normalized = value.to_s.strip.downcase
      CONFIDENCE_LEVELS.include?(normalized) ? normalized : 'low'
    end
  end
end
