# R as a Programming Language
# Michael Beven
# 20150921
# Data: None

require(stats)

# Printing of sparse (contingency) tables
set.seed(521)
t1 = round(abs(rt(200,df = 1.8)))
t2 = round(abs(rt(200, df = 1.4)))
table(t1, t2) # simple
print(table(t1,t2), zero.print = ".") # nicer to read

# Same for non-integer table:
T = table(t2, t1)
T = T * (1+round(rlnorm(length(T)))/4)
print(T, zero.print = ",") # quite nicer,
print.table(T[,2:8] * 1e9, digits=3, zero.print = ".")

# Corner cases with empty extents:
table(1, NA) # < table of extent 1 x 0 >

# Exercise
# Familiarise yourself with print() and other basic commands.  Print sqrt(3)
# to 2 digits, 12 digits and 32 digits of precision (what goes wrong?)

options(digits = 22)
round(print(sqrt(3)),32)

# Exercise
# Set variable x to sqrt(11) and compute log(x), exp(x), sin(x) and x^5

x = sqrt(11)
print(log(x))
print(exp(x))
print(sin(x))
print(x^5)

# Exercise
# Set a string variable a to your name, b to be the work "got", and combine those
# elements with x to print the equivalent of "Brian got 3.317"

a = "Michael"
b = "got"

sprintf("%s %s %2.3f",  a, b, 3.317)

# Exercise
# Create a 4 by 5 matrix X with elements x(i,j) = sin(i*pi/4)cos(j*pi/4)

i = matrix(rep(1:4,5), ncol = 5)
j = t(matrix(rep(1:5,4), ncol = 4))
x_ij = sin(i * pi / 4) * cos(j * pi / 3)

# Exercise
# Print all elements of X smaller than -0.1
print.table((x_ij < -0.1) * x_ij, zero.print = ".")

