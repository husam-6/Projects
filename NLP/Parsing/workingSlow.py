from nltk.tokenize import word_tokenize
import numpy as np

#class that stores all the information needed for CKY Parsing 
# - stores the nonterminals and the position of the prior rules
class items: 
    def __init__ (self, backtup1, backtup2, A, B1, C1, word_):
        self.back1 = backtup1
        self.back2 = backtup2
        self.rule = A
        self.B = B1
        self.C = C1
        self.word = word_

#function recursively calls itself to obtain the parse from the 
# matrix and output it in bracketted notation
def printTrees(item, out):
    addr1 = item.back1
    addr2 = item.back2
    
    if (item.C == None and item.B == None):  # need to specify the end of the parse 'ie houston]]]]]
        treeStruct.append('[' + item.rule + " " + item.word + ']')
        return 
    
    treeStruct.append('[' + item.rule)

    firstList = out[addr1[0], addr1[1]] 
    for obj in firstList: 
        if (obj == item.B):
            printTrees(obj, out)

    secondList = out[addr2[0], addr2[1]]
    for obj in secondList:
        if (obj == item.C):
            printTrees(obj,out)
            treeStruct.append(']')

#Function uses the bracket notation and prints it in the textual 
# parse tree format
def textualTree(output):
    quantity = ''
    indent = False

    for item in output: 
        n = len(item)
        if(item == ']'):
            quantity+= '\b' + '\b' + '\b'
            print(quantity + item)
        elif (indent == True):
            print(quantity + item)
        else:   
            print(quantity + item)
        if (item[n-1] != ']'):
            indent = True
            quantity+=' '*3

inp1 = input("Enter a grammar file (in CNF form): " )
print('Processing grammar...')
show = input("Would you like the textual parse trees to be shown? (y/n): ")

try:
    file = open(inp1, 'r')
    grammar = file.readlines()
except:
    print("Could not open grammar file")
    exit()



while(True):
    #pre process - strip words of puncutation and capitalization
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    sentence = input("Enter a sentence (type 'quit' to exit the program): ")
    if (sentence == 'quit'):
        break
    words = word_tokenize(sentence)
    words = [word.lower() for word in words if word.isalpha() or word.isdigit()]
    N = len(words)

    #create the parse chart - NxN array with each entry being a list
    out = np.empty((N+1,N+1), dtype=object)
    for cols in range(1,N+1):
        for rows in range(cols-1,-1, -1):
            out[rows,cols] = []
    #print(out)
    #CKY algorithm 
    for j in range(1,N+1):
        for line in grammar:
            x = line.split()
            if(x[2] == words[j-1]):
                item = items(None, None, x[0], None, None, words[j-1])
                out[j-1, j].append(item)
        for i in range(j-2, -1, -1):
            for k in range(i+1, j):
                for line in grammar: 
                    x = line.split()
                    if (len(x) == 4): 
                        for B in out[i,k]:
                            if (B.rule == x[2]):
                                for C in out[k,j]:
                                    if (C.rule == x[3]):
                                        item = items((i,k), (k,j), x[0], B, C, words[j-1])
                                        out[i,j].append(item)

    count = 0
    for item in out[0,N]:
        if ("S" == item.rule):
            count+=1
    
    if (count>=1):
        print("\nVALID SENTENCE!")
    
    count = 0
    for item in out[0,N]:
        treeStruct = []
        if item.rule == "S":
            count+=1
            printTrees(item, out)
            print('\n')
            print("Valid Parse # " + str(count) + ':' + '\n')
            output = ' '.join(treeStruct)
            #print(treeStruct)
            print(output)
            if (show == 'y'):
                print('\n')
                textualTree(treeStruct)

    if(count != 0):
        print("\nNumber of valid parses: " + str(count))
    else:
        print("\nNO VALID PARSES\n")

print("Yes sir!")