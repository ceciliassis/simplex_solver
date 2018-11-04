# require 'simplex_solver/version'

# Simplex Solver
module SimplexSolver
  def self.solve(rules)
    tb = Operations.new.tableau(rules)

    tb.each do |line|
      p line
    end
  end

  # Solver's operations
  class Operations
    def initialize
      @tb = []
    end

    def tableau(rules)
      build_tableau(rules)
      @tb
    end

    private

    def build_tableau(rules)
      z_func  = rules[0]
      vars    = z_func.size - 1
      n_rules = rules.size - 1 # remove linha z

      setup_lines(n_rules, rules[1], vars)
      build_labels(vars)
    end

    def setup_lines(n_rules, rule, vars)
      slacks = n_rules
      slacks *= 2 if rule[0] == :>=
      @tb = Array.new(slacks + 2) { Array.new(vars + slacks + 2) }
    end

    def build_labels(vars)
      first_line = @tb[0]

      first_line[0] = ''
      vars.times do |i|
        first_line[i + 1] = 'x' + (i + 1).to_s
      end
      first_line.drop(vars + 1).each_with_index do |_, i|
        first_line[i + vars + 1] = 's' + (i + 1).to_s
      end

      first_line[-1] = 'V'
    end
  end
end

# MAXIMIZACAO
restrictions = [
  [:max, 32, 17], # z
  [:<=, 3, 4, 3], # s1
  [:<=, 5, 6, 5], # s2
  [:<=, 7, 8, 7]  # s3
]

# restrictions = [
#   [:max, 32, 17], # z
#   [:>=, 3, 4, 3], # s1
#   [:<=, 5, 6, 5], # s2
#   [:<=, 7, 8, 7]  # s3
# ]

SimplexSolver.solve(restrictions)
