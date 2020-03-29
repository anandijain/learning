 
# data types 

i = 0 # int
f = 0. # float
l = [] # list
t = () # tuple, immutable
d = {} # dict

# lists aren't arrays

l2 = [i, f, l, t, d]

# for loop
for elt in l2:
    print(f'{elt}, {type(elt)}')
    
# functions

def fxn():
    print('hello')

# arguments in functions

def fxn2(s):
    print(s)

# return values

def fxn3(n):
    return n**2 # squared

# importance of data types

fxn3('a')
# TypeError: unsupported operand type(s) for ** or pow(): 'str' and 'int'
