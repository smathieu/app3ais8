f = File.open "rules.txt", "w"

1.upto(3) {|a|
  1.upto(3) {|b|
    1.upto(3) {|c|
      1.upto(3) {|d|
        res = a+b+c+d
        if res <= 4
          res = 1
        elsif res == 5
          res = 2
        elsif res == 6
          res = 2
        elsif res == 7
          res = 3
        elsif res == 8
          res = 4
        elsif res == 9
          res = 3
        elsif res == 10
          res = 2
        elsif res == 11
          res = 2
        elsif res == 12
          res = 1
        else
          res = 1
        end

        f.write "#{a} #{b} #{c} #{d}, #{res} (1) : 1\n"
      }
    }
  }
}

f.close

=begin
require "combo"

possible = []
4.times{ possible += [1,2,3]}
possible.sort!
puts possible.join " "
res = possible.combinations(4)

res.each{|x| puts x.join ' '}
=end
