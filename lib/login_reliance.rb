require 'mechanize'

module StatusCode
  LOGIN_FAILED = 0
  INVALID_LOGIN = 1
  LOGIN_SUCCESSFUL = 2
  ALREADY_LOGGED_IN = 3
end

class LoginReliance

  def initialize
    @save_file = File.expand_path('~/.reliance')
    @url = 'http://220.224.142.229/reliance/startportal_isg.do?CPURL=null'
    @url = 'http://reliancebroadband.co.in/reliance/startportal_isg.do'
  end

  def read_login_from_file
    begin
      File.open(@save_file) do |f|
        contents_array = f.gets.split(',')
        throw Exception.new if contents_array.size != 2
        return contents_array
      end
    rescue
    end
    nil
  end

  def remove_save_file
    File.delete(@save_file)
  end

  def get_login_from_user
    puts 'Enter username'
    username = STDIN.gets.chomp
    puts 'Enter password'
    password = STDIN.gets.chomp
    [username, password]
  end

  def save_login_to_file(username, password)
    File.open(@save_file, 'w') do |f|
      f.write "#{username},#{password}"
    end
  end

  def login_reliance(username, password)
    begin
      agent = Mechanize.new
      agent.get(@url) do |signin_page|
        if signin_page.body.include?("logout")
          return StatusCode::ALREADY_LOGGED_IN
        end
        success_page = signin_page.form_with(:name => 'form1') do |form|
          form.userId = username
          form.password = password
        end.submit
        unless success_page.body.include?("logout")
          return StatusCode::INVALID_LOGIN
        end
      end
    rescue Exception => ex
      puts ex.message
      return StatusCode::LOGIN_FAILED
    end
    return StatusCode::LOGIN_SUCCESSFUL
  end

  def login
    username, password = read_login_from_file
    if username.nil?
      username, password = get_login_from_user
      puts 'Do you want to save the login to a file in the home folder? (y/n)'
      answer = STDIN.gets[0].downcase
      if answer == 'y'
        save_login_to_file(username, password)
      end
    end
    login_reliance(username, password)
  end
end

repeat = false
repeat = (ARGV[0] == "-r") if ARGV.size > 0
reliance = LoginReliance.new

loop do
  statusCode = reliance.login
  if statusCode == StatusCode::LOGIN_FAILED
    puts "Login failed."
    unless repeat
      puts "Try login_reliance -r to keep trying again."
      break
    else
      puts "Trying again"
    end
  elsif statusCode == StatusCode::ALREADY_LOGGED_IN
    puts "Already logged in"
    break
  elsif statusCode == StatusCode::INVALID_LOGIN
    puts "Invalid login information"
    reliance.remove_save_file
  else
    puts "Login successful"
    break
  end
end
