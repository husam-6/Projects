#include "hash.h"
#include <iostream>
#include <list>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>
#include <cctype>

using namespace std; 

bool hasDigits(string& word)
{
    for (int i = 0; i < word.size(); i++)
    {
        if(isdigit(word[i]))
        {
            return true;
        }
    }
    return false;
}

tuple<string, int> split(string& line, int iterator)
{
    int nonChar = 0; 
    int j = iterator;
    while((isalnum(line[j]) || (line[j] == '\'') || (line[j] == '-'))==false)
    {
        nonChar++;
        j++;
    }

    string out = "";
    for(int i = iterator+nonChar; i<line.size(); i++)
    {
        if(isalnum(line[i]) || (line[i] == '\'') || (line[i] == '-'))
        {
            out+=line[i];
        }
        else
        {
            break; 
        }
    }

    return {out,nonChar}; 
}

int main()
{
    string test = "///////Um-deedledeedledeedle&///223ssd2%///%&um-deedleday";
    //string test = "/";
    int i = 0;
    auto [tmp, non] = split(test,i);
    cout << tmp << '\n';
    
    i += tmp.size()+non;

    auto [tmp2, non2] = split(test, i);
    cout << tmp2 << '\n';

    i += tmp2.size()+non2;

    auto [tmp3, non3] = split(test, i);
    cout << tmp3 << '\n';

    //cout << split(test, tmp.size()+1) << '\n';
    return 0;
}