require 'set'
require_relative 'matrix'

file_array = File.readlines('input.txt').map { |line| line.split.map(&:to_i) }

@invites = Set.new(file_array)
@customers = Set.new(@invites.to_a.flatten)
@matrix = Matrix.new(@customers.max)
@invited = Set.new
@graph = []

def has_next?(i)
  @invites.any? { |k,_| k == i }
end

def first_customer
  @invites.first.first
end

def find_predecessor_by(search)
  return if search == first_customer
  tmp = @graph.detect { |hash| hash[:friend] == search }
  tmp.fetch(:customer) {} if tmp
end

def build_graph(customer, friend, score = 0)
  predecessor = find_predecessor_by(customer)

  if predecessor && (has_next?(friend) || !@invited.include?(customer))
    Matrix.add_value(@matrix, predecessor, customer, score)
    @invited << customer
    parent = @graph.select {|hash| hash[:customer] == predecessor && hash[:friend] == customer}.first
    build_graph(parent[:customer], parent[:friend], score + 1)
  end

  { customer: customer, friend: friend, predecessor: predecessor }
end

def ranking
  @customers.map do |customer|
    { customer => Matrix.sum_values_row(@matrix, customer - 1) }
  end.sort_by { |hash| hash.values }.reverse
end

def print_ranking
  ranking.each do |score|
    next unless @customers.include?(score.keys.first)
    puts score
  end
end

@invites.each do |customer, friend|
  next if customer == friend
  @graph << build_graph(customer, friend)
end

print_ranking
