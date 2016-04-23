require 'pry'
require 'set'
require_relative 'matrix'

cinvites = File.readlines('input-full.txt').map do |line|
  line.split.map(&:to_i)
end

@invites = Set.new(cinvites)

@customers = Set.new(@invites.to_a.flatten)
@matrix = Matrix.new(@customers.max)
@invited = Set.new

@graph = []

def has_next?(i)
  @invites.any? { |k,_| k == i}
end

def find_predecessor_by(search)
  return if @invites.first.first == search
  tmp = @graph.detect { |hash| hash[:friend] == search }
  tmp.fetch(:customer, nil) if tmp
end

def build_graph(customer, friend, score = 0)
  predecessor = find_predecessor_by(customer)
  puts "customer: #{customer} - friend: #{friend} - predecessor: #{predecessor}"
  if predecessor
    if has_next?(friend)
      Matrix.add_value(@matrix, predecessor, customer, score)
      @invited << customer
      g = @graph.select {|hash| hash[:customer] == predecessor && hash[:friend] == customer}.first
      build_graph(g[:customer], g[:friend], score + 1)
    else
      unless @invited.include?(customer)
        Matrix.add_value(@matrix, predecessor, customer, score)
        @invited << customer
        g = @graph.select {|hash| hash[:customer] == predecessor && hash[:friend] == customer}.first
        build_graph(g[:customer], g[:friend], score + 1)
      end
    end
  end

  { customer: customer, friend: friend, predecessor: predecessor }
end

def print_ranking
  @customers.each_with_index do |customer, index|
    puts "#{index+1} - #{Matrix.sum_values_row(@matrix, index)}"
  end
end

@invites.each do |customer, friend|
  next if customer == friend
  puts "*"*80
  @graph << build_graph(customer, friend)
end

print_ranking
