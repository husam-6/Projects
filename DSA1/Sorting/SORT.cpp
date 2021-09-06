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
struct stuff 
{
  int extra;
  Data* ref; 
};

bool compareData(Data *&p1, Data *&p2)
{
  if (p1->lastName < p2->lastName)  
    return true; 
  else if (p1->lastName == p2->lastName)
    {
      if (p1->firstName < p2->firstName)
        return true;
      else if (p1->firstName == p2->firstName)
          if (p1->ssn < p2->ssn)
            return true;
    } 
  return false;
}

bool compareStuff(stuff &p1, stuff &p2)
{
  if (p1.extra<p2.extra)  
    return true; 
  else if (p1.extra == p1.extra)
    {
     return compareData(p1.ref, p2.ref);
        //still need a tiebreaker with the pointer object
    } 
  return false;

}


stuff given[1010100];
void sortDataList(list<Data *> &l) 
{
  int i = 0;

  for (list<Data *> :: iterator it = l.begin(); it != l.end(); it++)
  {
    string tmp = (*it)->lastName;
    char *pc = &tmp[0];

    stuff info;
    info.extra = *pc++;
    info.extra = ((info.extra)<<8) + *pc++;
    info.extra = ((info.extra)<<8) + *pc++;

    info.ref = *it;

    given[i] = info;

    i++;
  }

  sort(given, given + l.size(), &compareStuff);

  i = 0;
  for (list<Data *> :: iterator it = l.begin(); it != l.end(); it++)
  {
    *it = (given[i]).ref;
    i++;
 

  }



}