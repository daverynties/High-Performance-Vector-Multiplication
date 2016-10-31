# -*- coding: utf-8 -*-
"""
Created on Sat Oct 29 18:11:09 2016

@author: David A. Rynties

"""
a = []
b = []

total = 0;

num_values = 2048 * 8

def vector_init(total, max_value, list):
    for i in range (total):
        x = i % 8 + 1
        list.append(x)
        
vector_init(num_values, 8, a)
vector_init(num_values, 8, b)

for i in range(num_values):
    x = a[i] * b[i]
    total += x
    
print(total)
