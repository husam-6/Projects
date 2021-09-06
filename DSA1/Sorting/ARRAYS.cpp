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
          if (p1->ssn < p2->ssn)
            return -1;
    } 
  return 1;
}

void insertionSort(Data* given[], int start, int last)
{ 

  for(int i = start + 1; i <= last; i++)
  { 
    int j = i;
    Data *tmp;
    tmp = given[i]; 

    while(j > start && compareData(given[i],given[j-1]))
    {
      given[j] = given[j-1]; 
      j--; 
    } 
    given[j] = tmp;

  }
}

int choosePivot(Data* given[], int start, int last)
{
  int m = start + (last-start)/2;
  if(compareData(given[start],given[m]) < 0)
  {
    if (compareData(given[start],given[last]) > 0)
      return start;
    else if (compareData(given[m],given[last]) < 0)
      return m;
  }
  else
  {
    if (compareData(given[m],given[last]) > 0)
      return m;
    else if (compareData(given[start],given[last]) < 0)
      return last;
  }
  return last; 
}

int partition(Data* given[], int start, int last)
{
  int i = start; 
  int j = last;
  int k; 

  k = choosePivot(given, start, last);  

  swap(given[k], given[last]); 

  j--;

  while (true)
  {
    while (compareData(given[i],given[last]) < 0)
    {
      ++i;
      if(i ==last)
        break;
    }

    while (compareData(given[j],given[last]) > 0 && j>=i)
    {
      --j;
      if (j == start)
        break;
    }

    if (i>=j)
      break;

    swap(given[i], given[j]);
  }

  if (i > last )
    i = last;
  if (j < start )
    j = start;
  swap(given[i],given[last]);

  return i; 
}

void swap(Data *&pos1, Data *&pos2)
{
  Data *temp = pos1;  
  pos1 = pos2;
  pos2 = temp; 
}

void Quicksort(Data* given[], int left, int right)
{
  if( left >= right)
    return;
  if ((right - left) == 1)
  {
    int alpha = compareData(given[left], given[right]);
    if (alpha < 0)
      return;
    else if (alpha > 0)
      swap(given[left],given[right]);

  }

  //if((right - left) <= 15)
    //insertionSort(given,left,right);
  else 
  {
    int part = 0;

    part = partition(given, left, right);


    Quicksort(given, left, part - 1);


    Quicksort(given, part + 1, right);
  }
  return; 
}

void sortDataList(list<Data *> &l) 
{
  Data* given[l.size()];
  int i = 0;
  for (list<Data *> :: iterator it = l.begin(); it != l.end(); it++)
  {
    given[i] = *it;

    i++;
  }

  Quicksort(given, 0, l.size());

  i = 0;
  for (list<Data *> :: iterator it = l.begin(); it != l.end(); it++)
  {
    *it = given[i];
    i++;
  }


}