// THIS IS THE PROVIDED CODE FOR PROGRAM #2, DSA 1, FALL 2020

#include <iostream>
#include <fstream>
#include <sstream>
#include <list>
#include <vector>
#include <string>
#include <algorithm>
#include <ctime>
#include <cmath>
#include <cstring>
#include <cctype>
#include <cstdlib>

using namespace std;

// A simple class; each object holds four public fields
class Data {
public:
  string lastName;
  string firstName;
  string ssn;
};

// Load the data from a specified input file
void loadDataList(list<Data *> &l, const string &filename) {

  ifstream input(filename);
  if (!input) {
    cerr << "Error: could not open " << filename << "\n";
    exit(1);
  }

  // The first line indicates the size
  string line;
  getline(input, line);
  stringstream ss(line);
  int size;
  ss >> size;

  // Load the data
  for (int i = 0; i < size; i++) {
    getline(input, line);
    stringstream ss2(line);
    Data *pData = new Data();
    ss2 >> pData->lastName >> pData->firstName >> pData->ssn;
    l.push_back(pData);
  }

  input.close();
}

// Output the data to a specified output file
void writeDataList(const list<Data *> &l, const string &filename) {

  ofstream output(filename);
  if (!output) {
    cerr << "Error: could not open " << filename << "\n";
    exit(1);
  }

  // Write the size first
  int size = l.size();
  output << size << "\n";

  // Write the data
  for (auto pData:l) {
    output << pData->lastName << " " 
	   << pData->firstName << " " 
	   << pData->ssn << "\n";
  }

  output.close();
}

// Sort the data according to a specified field
// (Implementation of this function will be later in this file)
void sortDataList(list<Data *> &);

// The main function calls routines to get the data, sort the data,
// and output the data. The sort is timed according to CPU time.
int main() {
  string filename;
  cout << "Enter name of input file: ";
  cin >> filename;
  list<Data *> theList;
  loadDataList(theList, filename);

  cout << "Data loaded.\n";

  cout << "Executing sort...\n";
  clock_t t1 = clock();
  sortDataList(theList);
  clock_t t2 = clock();
  double timeDiff = ((double) (t2 - t1)) / CLOCKS_PER_SEC;

  cout << "Sort finished. CPU time was " << timeDiff << " seconds.\n";

  cout << "Enter name of output file: ";
  cin >> filename;
  writeDataList(theList, filename);

  return 0;
}

// -------------------------------------------------
// YOU MAY NOT CHANGE OR ADD ANY CODE ABOVE HERE !!!
// -------------------------------------------------

/*
  Husam Almanakly, DSA1 Program Assignment 2 
  
  This program 

*/

// You may add global variables, functions, and/or
// class defintions here if you wish.
 

int compareData(Data *&p1, Data *&p2)
{
  if (p1->lastName < p2->lastName)  
    return -1; 
  else if (p1->lastName == p2->lastName)
    {
      if (p1->firstName < p2->firstName)
        return -1;
      else if (p1->firstName == p2->firstName)
        {
          if (p1->ssn < p2->ssn)
            return -1;
        }      
    } 
  return 1;
}

void insertionSort(list<Data *> &l, list<Data *> :: iterator &start, list<Data *> :: iterator &last)
{ 

  for(list<Data *> :: iterator i = ++start; i != last; i++)
  { 
    list<Data *> :: iterator j = i;
    Data *tmp = *i; 
    list<Data *> :: iterator prev;

    while(j != l.begin() )
    {
      prev = j;
      prev--;
      if (compareData(tmp , *prev) < 0)
        *j = *prev;
      else 
        break; 
      j--; 
    } 
    *j = tmp;

  }
}

list<Data *> :: iterator choosePivot(list<Data *> &l, list<Data *> :: iterator start, list<Data *> :: iterator last)
{
  list<Data *> :: iterator m = start;
  int k = distance(start,last)/2;
  advance(m, k);
  return m; 
}

list<Data *> :: iterator partition(list <Data *> &l , list<Data *> :: iterator &start, list<Data *> :: iterator &last)
{
  list<Data *> :: iterator i = start; 
  list<Data *> :: iterator j = last;
    
  list<Data *> :: iterator k; 

  k = choosePivot(l, start, last);  

  swap(*k, *last); 

  j--; 

  while (i != l.end() && j != --l.begin())
  {
    bool crossed = false;

    int alpha = compareData(*i,*k);
    int beta = compareData(*j,*k);

    while (alpha < 0)
    {
      i++;
      if (i == l.end())
        break;
      alpha = compareData(*i,*k);
      if (i==j)
        crossed = true;
    }

    while (beta > 0 && !crossed)
    {
      j--;
      if(j == --l.begin())
        break;
      beta = compareData(*j,*k);
      if (i==j)
        crossed = true;
    }

    if (crossed)
      break; 
  
    swap(*i, *j);
  }

  if (i==l.end())
    i--;
  if (j == --l.begin())
    j++;

  swap(*i,*k);

  return i; 
}

void swap(Data *&pos1, Data *&pos2)
{
  Data *temp = pos1;  
  pos1 = pos2;
  pos2 = temp; 
}

void Quicksort(list<Data *> &l, list<Data *> :: iterator &start, list<Data *> :: iterator &last)
{
  list<Data *> :: iterator tmp;
  tmp = last;
  tmp--;

  int size= distance(start, tmp);
  //if(size <= 20)
    insertionSort(l,start,last);
  /*else 
  {
    list<Data *> :: iterator part;

    if( start == l.end() || last == --l.begin())
      return;
    if(start == tmp || start == last )
      return;

    part = partition(l, start, last);
    tmp = part;    

    Quicksort(l, start, --tmp);
    Quicksort(l, ++part, last);

  }
  */
  return; 
}

void sortDataList(list<Data *> &l) 
{
  list<Data *> :: iterator start;
  start = l.begin();
  
  list<Data *> :: iterator last;
  last = l.end();
  last--;


  Quicksort(l, start, last);


}