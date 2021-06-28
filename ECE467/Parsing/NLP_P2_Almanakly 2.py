from nltk.tokenize import word_tokenize
import numpy as np

inp1 = input("Enter a grammar file (in CNF form): " )
try:
    grammar = open(inp1, 'r')
except:
    print("Could not open grammar file")
    exit()

#pre process - strip words of puncutation and capitalization
sentence = input("Enter a sentence: ")
words = word_tokenize(sentence)
words = [word.lower() for word in words if word.isalpha()]
N = len(words)

#create the parse chart - NxN array with each entry being a list
out = np.empty((N+1,N+1), dtype=object)
for cols in range(1,N+1):
    for rows in range(cols-1,-1, -1):
        out[rows,cols] = []
#print(out)

#CKY algorithm 
for j in range(1,N+1):
    grammar.seek(0)
    for line in grammar:
        x = line.split()
        if(x[2] == words[j-1]):
           out[j-1, j].append(x[0])
    for i in range(j-2, -1, -1):
        for k in range(i+1, j):
            grammar.seek(0)
            for line in grammar: 
                x = line.split()
                if (len(x) == 4): 
                    

                                    
                        
                        

count = 0
if("S" in out[0,N]):
    print("VALID SENTENCE")
    for item in out[0,N]:
        if item == "S":
            count+=1
    print("Number of valid parses: " + str(count))
else:
    print("NO VALID PARSES")


#for line in grammar: 
 #   print(line)