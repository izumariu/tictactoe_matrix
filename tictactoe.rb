#!/usr/bin/ruby
require 'serialport'
require 'socket'
require 'timeout'
def timeprompt;return "["+Time.now.to_s.split(" ").slice(0,2).join(" ")+"]";end
#ip_addr = `ip address`.match(/wlp2s0.+\n.+\n[ \n\t\r\f]+inet \d*\.\d*\.\d*\.\d*/).to_s.split(/[ \n\t\r\f]+/).pop.split(".")
ip_addrsss = Socket.ip_address_list
ip_addrsss.map!{|i|i.ip_address}
ip_addrsss.length.times{|t| puts "#{t}) #{ip_addrsss[t]}"}
print("Which IP?> ")
ip_address = ip_addrsss[gets.chomp.to_i].split(".")
ip_address.map!{|segment|x=segment;(3-x.length).times{x=" "+x};x}
p ip_address
print("Device?> ")
devname = gets.chomp
print("Baud?> ")
devbaud = gets.chomp.to_i
$ser = SerialPort.new(devname, devbaud) rescue (puts("ERROR");exit(0))
at_exit{$ser.close}
puts "#{timeprompt} Initializing...."
sleep 1
$ser.write("!22")
sleep 0.01
$ser.write("22")
sleep 2
for segment in ip_address
	$ser.write(segment)
	sleep 0.5
end
sleep 3
server = TCPServer.new(23)
puts "#{timeprompt} Server is now accessible"
c1 = true
c2 = true
q = []
$field = [
	[" "," "," "],
	[" "," "," "],
	[" "," "," "]
]

$COMMANDS = {
	"STOP" => 0,
	"START"=> 1,
	"x11"  => 2,
	"x21"  => 3,
	"x31"  => 4,
	"x12"  => 5,
	"x22"  => 6,
	"x32"  => 7,
	"x13"  => 8,
	"x23"  => 9,
	"x33"  => 10,
	"o11"  => 11,
	"o21"  => 12,
	"o31"  => 13,
	"o12"  => 14,
	"o22"  => 15,
	"o32"  => 16,
	"o13"  => 17,
	"o23"  => 18,
	"o33"  => 19,
	"xWIN" => 20,
	"oLOSE"=> 20,
	"oWIN" => 21,
	"xLOSE"=> 21,
	"RESET"=> 22,
	"DRAW" => 23
}

$playing = false
$c1in = false
$c2in = false

def prompt(c,m,oc)
	c.puts
	c.puts("   1 "           +"   2   3 x")
	c.puts("  +--"           +"-+---+---+")
	#c.puts("  |  "           +" |   |   |")
	c.puts("1 | #{$field[0].join(" | ")} |")
	c.puts("  +--"           +"-+---+---+")
	c.puts("2 | #{$field[1].join(" | ")} |")
	c.puts("  +--"           +"-+---+---+")
	c.puts("3 | #{$field[2].join(" | ")} |")
	c.puts("y +--"           +"-+---+---+")
	c.puts
	c.puts("Enter the coordinates of the field youto place your mark in.")
	c.puts("Example: '21' entered by Player 1 would")
	c.puts("place X in the right field of the middle row.")
	c.puts
	
	resp_coords = []
	until resp_coords!=[]
		c.print("coords> ");
			#xnoidle = Thread.new{sleep 30;c.puts("You idled too long. Your opponent wins.");oc.puts("You win because your opponent idled too long!");puts("#{timeprompt} #{m} was kicked because of idleing too long");c.close;oc.close;$playing=false;$ser.write($COMMANDS[m+"LOSE"].to_s)}
			(resp = c.gets.chomp.split("#").pop) rescue nil
			#xnoidle.kill
			if !(c.closed?&&oc.closed?)
				resp.length==2 rescue resp=""
				(resp.length==2 && resp[0].ord-48<9 && resp[1].ord-48<9) ? (resp_coords = [resp[1].to_i,resp[0].to_i];puts "#{timeprompt} #{m} => #{resp_coords.reverse.inspect}") : (resp_coords=[];puts "#{timeprompt} #{m} issued '#{resp}'")#c.puts "Seems like you don't want to play - quitting.";$playing=false)
				if $playing&&resp_coords!=[]
					if $field[resp_coords[0]-1][resp_coords[1]-1]!=" "
						c.puts("This field is already claimed by #{$field[resp_coords[0]-1][resp_coords[1]-1]==m ? "you" : "your opponent"}! Choose another one!")
						resp_coords=[]
					else
						$field[resp_coords[0]-1][resp_coords[1]-1] = m
					end
				end
			else
				resp_coords=nil
			end
		end
		if !(c.closed?&&oc.closed?)
			puts;puts("   1 "           +"   2   3 x");puts("  +--"           +"-+---+---+");puts("1 | #{$field[0].join(" | ")} |");puts("  +--"           +"-+---+---+");puts("2 | #{$field[1].join(" | ")} |");puts("  +--"           +"-+---+---+");puts("3 | #{$field[2].join(" | ")} |");puts("y +--"           +"-+---+---+");puts
			$ser.write($COMMANDS[m+resp].to_s)
		end
end

def checkForBingo
	return "x" if (($field[0][0]=="x"&&$field[0][1]=="x"&&$field[0][2]=="x") || ($field[0][0]=="x"&&$field[1][0]=="x"&&$field[2][0]=="x") || ($field[0][0]=="x"&&$field[1][1]=="x"&&$field[2][2]=="x"))
	return "x" if (($field[2][2]=="x"&&$field[2][1]=="x"&&$field[2][0]=="x") || ($field[2][2]=="x"&&$field[1][2]=="x"&&$field[0][2]=="x") || ($field[0][2]=="x"&&$field[1][1]=="x"&&$field[2][0]=="x"))
	return "x" if (($field[1][2]=="x"&&$field[1][1]=="x"&&$field[1][0]=="x") || ($field[2][1]=="x"&&$field[1][1]=="x"&&$field[0][1]=="x"))
	return "o" if (($field[0][0]=="o"&&$field[0][1]=="o"&&$field[0][2]=="o") || ($field[0][0]=="o"&&$field[1][0]=="o"&&$field[2][0]=="o") || ($field[0][0]=="o"&&$field[1][1]=="o"&&$field[2][2]=="o"))
	return "o" if (($field[2][2]=="o"&&$field[2][1]=="o"&&$field[2][0]=="o") || ($field[2][2]=="o"&&$field[1][2]=="o"&&$field[0][2]=="o") || ($field[0][2]=="x"&&$field[1][1]=="x"&&$field[2][0]=="x"))
	return "o" if (($field[1][2]=="o"&&$field[1][1]=="o"&&$field[1][0]=="o") || ($field[2][1]=="o"&&$field[1][1]=="o"&&$field[0][1]=="o"))
	return nil
end

loop do
	c1 = server.accept
	c1_sock_domain, c1_remote_port, c1_remote_hostname, c1_remote_ip = c1.peeraddr
	c1.puts("Welcome to Tic Tac Toe! You are the 1st player( X ). Please wait for a 2nd player to log in.")
	c1in = true
	puts("#{timeprompt} P1 logged in => #{c1_remote_ip}(#{c1_remote_hostname})")
	c2 = server.accept
	c2_sock_domain, c2_remote_port, c2_remote_hostname, c2_remote_ip = c2.peeraddr
	c1.puts("The 2nd player logged in. Game starts. Your opponent is '#{c1_remote_hostname}'.")
	puts("#{timeprompt} P2 logged in => #{c2_remote_ip}(#{c2_remote_hostname})")
	$ser.write("1")
	c1.puts("Player 2 begins.")
	c2.puts("Wecome to Tic Tac Toe! You're the 2nd player( O ). Your opponent is '#{c1_remote_hostname}'. You may begin.")
	$c2in = true
	xabort = Thread.new{loop{Thread.start(server.accept){|c3|c3.puts("Sorry, server is full. Try again later.");c3.close;puts("#{timeprompt} Another P tried to log in")}}}
	$playing = true
	xshell = Thread.new{loop{gets.chomp=="next"&&(c1.close;c2.close)}}
	9.times{|i|
		if i%2==0
			#PLAYER2's TURN
			c1.puts("Waiting for Player 2...")
			prompt(c2,"o",c1)
			break if c1.closed?&&c2.closed?
			(c1.puts("I'm sorry, but your opponent quit the game.");break) if !$playing
			round = checkForBingo
			sleep 1
			break if round!=nil
		else
			#PLAYER1's TURN
			c2.puts("Waiting for Player 1...")
			prompt(c1,"x",c2)
			break if c1.closed?&&c2.closed?
			(c2.puts("I'm sorry, but your opponent quit the game.");break) if !$playing
			round = checkForBingo
			sleep 1
			break if round!=nil
		end
	}
	if !(c1.closed?&&c2.closed?)
		case checkForBingo
		when "x"
			$ser.write($COMMANDS["xWIN"].to_s)
			c1.puts("YOU WON!")
			c2.puts("X won!")
			puts("#{timeprompt} X won");
		when "o"
			$ser.write($COMMANDS["oWIN"].to_s)
			c2.puts("YOU WON!")
			c1.puts("O won!")
			puts("#{timeprompt} O won");
		when nil
			$ser.write($COMMANDS["DRAW"].to_s)
			c2.puts("It's a draw!")
			c1.puts("It's a draw!")
			puts("#{timeprompt} DRAW")
		end
	else
		$ser.write($COMMANDS["STOP"].to_s)
	end
	$field = [
		[" "," "," "],
		[" "," "," "],
		[" "," "," "]
	]
	c1.close rescue nil
	c2.close rescue nil
	xabort.kill
end
