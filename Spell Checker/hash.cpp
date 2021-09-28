#include "hash.h"

/*
    Husam Almanakly - DSA2 Program 1

    This program implements a Hash Table data structure, with the purpose to 
    read in and spell check a given document (given a dictionary). This file
    (hash.cpp) contains all the files and implementations of the Hash Table data
    structure, required from the header file. 

    The File labelled spellcheck.cpp parses the inputted dictionary, inserting elements into a 
    hash table, and reads in a text document. It checks if each item exists in the hash table
    and records which items are unknown, (including words above 20 characters).

    Makefile is provided, run make to create the executable spell.exe

*/

using namespace std; 

//Constructor -> initialize the size using getPrime and make every entry a default hashItem()
//Capacity gets the size of the vector
hashTable::hashTable(int size)
{
    filled = 0; 
    capacity = getPrime(size);
    data.resize(capacity);
    for(auto& entry: data)
    {
        entry = hashItem();
    } 
}

//insert function -> check if key exists, if it does - linear probing
//else, insert 
int hashTable::insert(const string &key, void *pv)
{
    int returnVal = 0;
    filled++; 
    //cout<<double(filled)/double(capacity)<<'\n';
    if((double(filled)/double(capacity))>0.5) 
    {
        bool fail = rehash(); 
        if(!fail)
        {
            return 2; 
        }
    }
    int pos = hash(key);
    //cout << pos << '\n';
    if(data[pos].isOccupied)
    {
        returnVal = 1;
        while(data[pos].isOccupied)
        {
            if(pos==capacity-1)
            {
                pos = 0; 
            }
            else
            {
                pos++; 
            }
        }
    }
    data[pos].key = key; 
    data[pos].isOccupied = true; 

    return returnVal; 
}

//Contains function -> checks if the hash table has a hashItem object 
//occupying that position
bool hashTable::contains(const string &key)
{
    int i = findPos(key); 
    if(i == -1)
    {
        return false;
    }
    return true; 
}

//Lazy delete for linear probing
//Not needed for project 1, but included anyway
bool hashTable::remove(const string &key)
{
    int tmp = findPos(key);
    if(tmp>0)
    {
        data[tmp].isDeleted = true; 
        return true; 
    }
    return false; 
}


//Hash function -> from https://www.geeksforgeeks.org/string-hashing-using-polynomial-rolling-hash-function/
//Polynomial Rolling Hash function
//Returns unsigned int to avoid negative hash keys
int hashTable::hash(const string &key)
{
    // P and M
    int p = 31;
    int m = 1e9 + 9;
    long long power_of_p = 1;
    unsigned hash_val = 0;
 
    // Loop to calculate the hash value
    // by iterating over the elements of string
    for (int i = 0; i < key.length(); i++) {
        hash_val
            = (hash_val
               + (key[i] - 'a' + 1) * power_of_p)
              % m;
        power_of_p
            = (power_of_p * p) % m;
    }
    return hash_val%capacity;
}

//Goes to the hashed position and linearly searches for the given
//key until it is either found or an 'empty' box is reached
int hashTable::findPos(const string &key)
{
    int pos = hash(key);
    while(data[pos].isOccupied)
    {
        if(data[pos].key == key && data[pos].isDeleted == false)
        {
            return pos; 
        }
        else
        {
            if(pos == capacity)
            {
                pos = 0; 
            }
            else
            {
                pos++; 
            }
        }
    }
    return -1;
}

//Rehash function, resizes the original data array, storing entries
//in a temporary array. After catching any errors allocating extra memory, 
//insertions are repeated for any items in the old array that had an existing 
//element in it
bool hashTable::rehash()
{
    int newSize = getPrime(capacity);
    //cout<<newSize<< "   " << capacity << '\n';
    vector<hashItem> tmp = data; 
    data.clear();
    filled = 0;  

    try
    {
        data.resize(newSize);
    }
    catch(const bad_alloc &error)
    {
        return false; 
    }
    capacity = newSize;

    for(int i = 0; i<tmp.size(); i++)
    {
        if((tmp[i].isOccupied == true) && (tmp[i].isDeleted == false))
        {
            insert(tmp[i].key);
        }
    }

    //data = tmp; 
    return true; 
}

//Gives a prime number at least as large as the given size
//Array is spaced out to be more than double the size of the previous 
unsigned int hashTable::getPrime(int size = 0)
{
    int primeNums[8] =  {98317, 393241, 1572869, 6291469, 25165843, 100663319, 402653189, 1610612741};
    for(int i = 0; i<11; i++)
    {
        if(primeNums[i]>size)
        {
            return primeNums[i];
        }
    }
    return primeNums[4];
}

//Function to display all the inputted items into the hash table
//Used for testing/debugging 
void hashTable::showVals(std::string &out)
{
    std::ofstream output;
    output.open(out);

    for(int i = 0; i<data.size(); i++)
    {
        output<< i << "      " << data[i].key << '\n';
    }
    output.close();
}