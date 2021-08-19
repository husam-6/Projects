#!/usr/bin/env python
# coding: utf-8

# In[96]:


import math
import collections
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer 
ps = PorterStemmer()

#add probs*freq
#dictionaries
categories = dict() #store a dictionary for every category in categories, nested dictionary has keys "words" and values = frequency
likelihood = dict()
categoryCount = dict()
vocab = dict()
prior = dict()

#try wordnet morphological base 
#try convert start of sentence to lowercase
#maybe remove puncuation
#loop through all documents, storing words into "categories" by category, as a dictionary of words (so a dictionary of dictionaries) 
def tokenize(articlePath, category):
    if (categories.get(category) == None):
        categories[category] = dict()
    fin = open(articlePath, 'r')
    tokens = word_tokenize(fin.read())
    newTokens = [ps.stem(token) for token in tokens if token.isalpha()]
    unique = list(set(newTokens))
    for word in unique:
        stemmed = ps.stem(word)
        if (stemmed not in categories.get(category)):
            categories.get(category)[stemmed] = 1
        else: 
            categories.get(category)[stemmed] += 1
        if (stemmed not in vocab):
            vocab[stemmed] = 1
    return categories

#calculates the prior prob and the likelihood probs 
def train(totalFiles):  
    #Likelihood and Prior Probabilities
    for category in categories:
        prior[category] = categoryCount.get(category)/totalFiles
        if (category not in likelihood):
            likelihood[category] = dict()
        for word in vocab:
            if (word not in categories.get(category)):
                wordFreq = 0
            else:
                wordFreq = categories.get(category).get(word)
            likelihood.get(category)[word] = math.log10((wordFreq + 0.1)/(categoryCount.get(category))) #maybe use testSetfiles
    return likelihood

#use stored info to find max prob => category to choose 
def test(doc):
    sumC = dict()
    fin = open(doc, 'r')
    tokenIn = word_tokenize(fin.read())
    freq = collections.Counter(tokenIn)
    for category in categories:    
        sumC[category] = prior.get(category)
        for word in tokenIn:
            if (word.isalpha()):
                stemmed = ps.stem(word)
                if (stemmed in vocab):
                    sumC[category] += likelihood.get(category).get(stemmed)  
    return max(sumC, key=sumC.get) 

#MAIN: take user inputted files
try:
    inp = input("Enter the training document file: ")
    initial = open(inp, 'r')
    inp2 = input("Enter the test document file: ")
    testDoc = open(inp2, 'r')
    inp3 = input("Enter the name of the output file: ")
    output = open(inp3, 'w')
except: 
    print("Error: could not find file")


#iterating line by line so I can tokenize all the words and note their frequency, storing # of files in each category 
totalFiles = 0
for line in initial: 
    totalFiles += 1
    x = line.split()
    countedWords = tokenize(x[0], x[1]) #tokenize all the words in the training set
    if (x[1] not in categoryCount):
        categoryCount[x[1]] = 1
    else:
        categoryCount[x[1]] += 1

#Train the program using inputted corpus
train(totalFiles) 

#test using inputted test document, write output into user inputted output file
for path in testDoc:
    y = path.split()
    output.write(y[0] + " " + test(y[0]) + "\n" )
output.close()


#print(len(categories))
#print(categoryCount)
#print(categories)
#print(likelihood)
#print(categories.keys())
#print(totalWords)




