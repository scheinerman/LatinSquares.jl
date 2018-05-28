# tools for displaying latin squares

# alphabets

abc = [ "$ch" for ch in 'a':'z']
ABC = uppercase.(abc)
greek = [ "$(Char(t))" for t in 945:969 if t != 962 ]
GREEK = uppercase.(greek)
