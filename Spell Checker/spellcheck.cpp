#include "hash.h"

using namespace std;

//function to get the number of seconds 
double getCpuTime() {
    return (double) clock() / CLOCKS_PER_SEC;
}

//function reads in the dictionary, inserts each element
void readInDict(string &dict, hashTable &table)
{
    string line; 
    ifstream dictionary;
    dictionary.open(dict); 

    while(getline(dictionary, line))
    {
        //line = toLower(line);
        transform(line.begin(), line.end(), line.begin(), ::tolower);
        table.insert(line);
    }
    
    dictionary.close();
}

//Function parses inputted string according to valid characters
//allowed. Returns the string and the number of extra characters preceding 
//'Builds' each word character by character
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

//Function checks if the word has any numbers in it 
//Used to decide if a word must be considered or not
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

//Function parses input document line by line, using split function
//to parse lines. Checks if a word is too long, or if its known or not
void spellCheck(string &doc, string &out, hashTable &table)
{
    string line; 
    ifstream document;
    ofstream output; 
    output.open(out);
    document.open(doc);
    
    int lineNumber = 1; 
    while(getline(document, line))
    {
        //make the entire line lowercase, build
        //the word limiting it to 20 chars 
        transform(line.begin(), line.end(), line.begin(), ::tolower);

        int nonChar = 0; 
        int i = 0;
        while(i<line.size())
        {
            //string word; 
            auto [word, non] = split(line, i);
            //cout << word << '\n'; 
            if(word == "")
            {
                break; 
            }
            i += word.size()+non;

            if(hasDigits(word))
            {
                continue; 
            }

            if(word.size()>20)
            {
                //write error
                output << "Long word at line " << lineNumber << ", starts: " << word.substr(0,20) << '\n';
                continue;  
            }
            else
            {
                if(table.contains(word) == false)
                {
                    //word not recognized 
                    output << "Unknown word at line " << lineNumber << ": " << word << '\n';
                    continue; 
                }   
            }
        }
        lineNumber++;
    } 
}

//Main, calls the functions to read in the dict and test file
//reports the cpu time to execute in seconds
int main()
{   
    //Read in dictionary file and text file... 
    //Note: not checking if file is valid yet...
    string doc, dict, output;
    hashTable table(1000);
    cout << "Enter the name of a dictionary text file: ";
	cin >> dict; 

    double start = getCpuTime();
    readInDict(dict, table);
    double end = getCpuTime();
    double duration = end-start;
    cout<<"Time taken to read in Dictionary (in seconds): " << duration << '\n';

    //spell check the document and report time
	cout<< "Enter the name of a document to spell check: ";
	cin >> doc;
    cout << "Enter the name of an output file: ";
    cin >> output;

    double start2 = getCpuTime();
    spellCheck(doc, output, table);
    double end2 = getCpuTime();
    double duration2 = end2 - start2; 
    cout<<"Time taken to spell check the document (in seconds): " << duration2 << '\n';

    string out = "values.txt";
    table.showVals(out);

    return 0; 
}