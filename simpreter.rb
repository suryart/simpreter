# Simpreter AKA Simple Interpreter is small scope and its variable parser.
# Author: Surya
# Created At: 20/09/2012 21:23

class Simpreter

  attr_accessor :input_array, :hash
  
  def initialize
    @input_array = []
    @forward_square_brackets = 0
    @backward_square_brackets = 0
    @hash = Hash.new { |hash,key| hash[key] = [] } # Hash of key to have array
    puts init_message
  end

  def start
    get_input # Get start with taking input
    parse_input # after input parse and show output
  end

  private

  def init_message
    init_message  = %Q|Welcome to Simpreter!!\n
    Kindly, start with writing a rectangular bracket '[' and then values like: a 10 in last ']' to see all values i.e. 
    [ 
      a 10 
      print a
    ]
    to see its values if exist in that scope.\n|%
    init_message
  end

  def get_input
    puts "Start from here:"
    while true
      print " "*(@forward_square_brackets - @backward_square_brackets)
      input_string = gets.chop.downcase # get input in downcases and remove last space
      input_array << input_string # insert string into array
      halt_with_error_message unless input_array.first == "[" # Must begin with '[' otherwise halt and show error message if doesn't start with square bracket
      if input_string == "[" # if forward bracket then increment it by one
        @forward_square_brackets +=1
      elsif input_string == "]" # if backward bracket then increment it by one
        @backward_square_brackets +=1
        break if brackets_equal? # brackets are equal? then break!
      end
    end
  end

  def halt_with_error_message
    input_array.clear # Clear array to start fresh!!
    @forward_square_brackets = 0 # init forward bracket
    @backward_square_brackets = 0 # init backward bracket
    print "Hey, your input must start with an opening square bracket '[' and must end with a closing square bracket ']'. Do you want me to continue? Press y/n (y- Yes to continue/ n- No to exit): "
    confirm_string = STDIN.gets # Confirm if user wants to exit or not?
    ((confirm_string.chop.downcase == "n") ? exit : ((confirm_string.chop.downcase == "y") ? get_input : halt_with_error_message )) # no? :( to exit | y? to continue :) | something else? huh, take it 
  end

  def parse_input
    remove_outer_scope # remove first and last brackets
    input_array.each do |input| # for each value in array
      begin
        add_new_scope if input.include?('[') # if forward bracket then add a scope
        remove_upper_scope if input.include?(']') # if backward bracket then remove a scope
        input.include?("print") ? display_output(input) : parse_variables(input) # value has print? then display otherwise keep processing
      rescue => exception
        puts 0 if exception.class == NameError
      end
    end
  end

  def brackets_equal?
    @forward_square_brackets == @backward_square_brackets # If matches then show result and exit
  end

  def remove_outer_scope
    input_array.shift # remove first value
    input_array.pop # remove last value
  end

  def add_new_scope
    hash.each { |k,v| hash[k].unshift('.') } # add input into array of hash's key value
  end

  def remove_upper_scope
    hash.each { |k,v| hash[k].each { |e| hash[k].shift; break if (e == '.'); } } # remove the value according to key
  end

  def display_output(input)
    key = input.split(" ").last # get the key
    value = hash[key] # Value from hash
    puts value.find { |input| input != "." }.to_i # print with a new line
  end

  def parse_variables(input)
    str_array = input.split(" ") # get splitted string
    first_value = str_array[0] # read first value
    hash[first_value].unshift( (str_array[1].to_i != 0) ? str_array[1] : hash[str_array[1]].find{|input| input != "."}.to_i) if first_value != '[' && first_value != ']' 
  end

end