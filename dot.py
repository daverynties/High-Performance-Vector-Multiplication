# -*- coding: utf-8 -*-
"""
Created on Sat Oct 29 18:11:09 2016

@author: 

"""
from timeit import default_timer as timer

a = []
b = []

num_values = 2048 * 1000

def vector_init(total, max_value, list):
    for i in range (total):
        x = i % 8 + 1
        list.append(x)
        
def calc_vectors():
    total = 0
    for i in range(num_values):
        x = a[i] * b[i]
        total += x
    return total
        
vector_init(num_values, 8, a)
vector_init(num_values, 8, b)

start = timer()
x = calc_vectors()
end = timer()
    
print("Dot Product Value:", x)
print("Total Vector Size:", num_values)
print("Execution Time:", end - start)
