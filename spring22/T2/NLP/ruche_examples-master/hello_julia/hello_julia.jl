using Distributions

println("Hello world!")

d = Normal()
x = rand(d, 10)

println("10 random numbers using package Distributions : ", x)
