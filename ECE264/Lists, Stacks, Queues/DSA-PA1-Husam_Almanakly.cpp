#include <iostream>
#include <fstream>
#include <sstream>
#include<list>

using namespace std;

/*
	Husam Almanakly - DSA1 Program Assignment 1 

	This program implements a singly linked SimpleList base abstract class, with a derived Stack and Queue class. Using the implemented classes, the program 
	parses through a given input file line by line and executes the appropriate command (creating a stack/queue, pushing onto one, or popping form one), outputting the appropriate comments to an output file.  

*/


//SimpleList Class (Singly Linked List)
template <typename T>
class SimpleList
{
	private:
		class Node 				// Nested Node class, stores a data member of type T and a pointer to the next node 
			{
			public:
				T data;
				Node *next;  
				
				Node(T object, Node *n = nullptr)   // Node constructor, initializes next pointer to nullptr
				{
					data = object; 
					next = n; 		// node passed in will be the following node in the sequence
				}
			};
		Node *Head; 			// Head, Tail pointers, name and size of the SimpleList
		Node *Tail;
		string Name;
		int size;


	protected: 
		void insertStart(T Object);			// function declaration for inserting at the start/end and removing from the start
		void insertEnd(T Object);
		T removeStart();					// these three functions alone can implement a stack and a queue

	public:
		string getName()						// getter to obtain the name of the simpleList
		{
			return Name;
		}

		virtual void push(T Object) = 0; 				// pure virtual declaration of push and pop functions
		virtual T pop() = 0; 

		SimpleList(string &n)							// SimpleList constructor (initializes default values and assigns the name to the data member)
		{
			Name = n;
			size = 0;
			Head = nullptr; 
			Tail = nullptr; 
		}

		int getSize()						// getter for the Size data member
		{
			return size; 
		}
};

template <typename T>
void SimpleList<T> :: insertStart(T Object)						// template function to insert at the start of the stack/queue
{
	Node *addedNode;
	if(getSize() == 0)										// Head and Tail point to first Node when size is 0
	{
		addedNode = new Node(Object);
		Head = addedNode;
		Tail = addedNode;
	}
	else if (getSize() > 0)									// pass in head, new node points to Head and update head to the current Node being added
	{
		addedNode = new Node(Object, Head);
		Head = addedNode;
	}
	++size;
}

template <typename T> 
T SimpleList<T> :: removeStart()						// template function to remove from the beginning of the stack/queue
{
	T exitN; 
	if (getSize()>0)
	{
		exitN = Head->data;  			 //exitN stores the data of the node Head points to, that will ultimately be removed 
		Node *temp = Head;
		Head = Head->next; 
		delete temp; 					// returns data member and free's memory of the SimpleList
		--size;
	}
	return exitN;
}

template <typename T>
void SimpleList<T> :: insertEnd(T Object)				// template function for inserting at the end
{
	Node *addNode; 
	if (size == 0)
	{
		addNode = new Node(Object);					// head and tail point to first node
		Head = addNode;
		Tail = addNode;
	}

	else if (size>0)
	{
		addNode = new Node(Object);					// pass in object as data, update the next node of addedNode to be the tail
		Tail->next = addNode;
		Tail = addNode; 
	}
	++size;
}

template <typename T>									// Stack class with a pop (removeStart) and a push (insertStart)
class Stack : public SimpleList<T>					
{
public: 	
	Stack(string n1) : SimpleList<T>(n1) {}					//Stack constructor (using the SimpleList constructor)

	T pop()
	{
		return SimpleList<T>::removeStart();
	}

	void push(T Object) 
	{
		SimpleList<T>::insertStart(Object);
	}
};

template <typename T>										//Queue class with a pop (removeStart) and a push (insertEnd)
class Queue : public SimpleList<T>							
{
public: 
	Queue(string n1) : SimpleList<T>(n1) {}					//Queue constructor (using the SimpleList constructor)

	T pop()
	{
		return SimpleList<T>::removeStart();
	}

	void push(T Object)
	{
		SimpleList<T>::insertEnd(Object);
	}
};


list<SimpleList<int> *> listI;  			//Declaration of lists that will hold the stacks and queues in respective places according to type
list<SimpleList<double> *> listD;
list<SimpleList<string> *> listS;


template <typename T>
SimpleList<T>*  searchName(list<SimpleList<T> *> &pList, string &name)				// searchName function to parse each list, returns nullptr if doesn't exist
{																					// if list exists returns the pointer to that List 
	for(auto it : pList)
	{
		if (it->getName() == name)
			return it; 
	}
	return nullptr;
}

void applyOperations(string &inp, string &out)								// function to parse through input and apply commands
{

	ifstream file; 										// files streams for input and output
	file.open(inp);

	ofstream Output;
	Output.open(out);

	string Line;


	while (getline(file, Line))							// loops through each line of the file until the file is read 
	{
		stringstream words(Line);
		string command, name, info;

		words >> command;										// first word of the line gets stored in command (push, pop, or create)
		words >> name;											// name of the list gets stored in name 

		Output << "PROCESSING COMMAND: " << Line << '\n'; 

		if (command == "create")
		{
			words >> info; 											// for create, stack or queue gets stored in info 
			if (name[0] == 'i')										// checks type of list (int, double, or string)
			{
				SimpleList<int> *addressi;								
				addressi = searchName<int>(listI, name);				// searches through integer list of SimpleLists and returns pointer to that list

				if (addressi == nullptr)						// checks that the list doesn't exist already 
			 	{
			 		SimpleList<int> *temp; 
			 		if (info == "stack")						// creates a stack/queue
					{
			 			temp = new Stack<int>(name);
					}
					else if (info == "queue")
					{
						temp = new Queue<int>(name);
					}
					listI.push_front(temp);						// adds created list to listI
			 	}
			 	else if (addressi != nullptr)								// checks if the list exists already 
			 	{
			 		Output << "ERROR: This name already exists!" << '\n';
			 	}
			}
			if (name[0] == 'd')
			{
				SimpleList<double> *addressd;								// same methods used for double and string instances...
				addressd = searchName<double>(listD, name);

				if (addressd == nullptr)
			 	{
			 		SimpleList<double> *temp; 
			 		if (info == "stack")
					{
			 			temp = new Stack<double>(name);
					}
					else if (info == "queue")
					{
						temp = new Queue<double>(name);
					}
					listD.push_front(temp);
			 	}
			 	else if (addressd != nullptr)
			 	{
			 		Output << "ERROR: This name already exists!" << '\n';
			 	}
			}
			if (name[0] == 's')
			{
				SimpleList<string> *addressS;
				addressS = searchName<string>(listS, name);

				if (addressS == nullptr)
			 	{
			 		SimpleList<string> *temp; 
			 		if (info == "stack")
					{
			 			temp = new Stack<string>(name);
					}
					else if (info == "queue")
					{
						temp = new Queue<string>(name);
					}
					listS.push_front(temp);
			 	}
			 	else if (addressS != nullptr)
			 	{
			 		Output << "ERROR: This name already exists!" << '\n';
			 	}
			}
		}	 	

		else if (command == "push")	
		{
			words >> info; 										// if command is push, info gets the data that should be pushed onto the list 
			if (name[0] == 'i')
			{
				int numI =  stoi(info); 						// conversion of string to int, stored in numI
				SimpleList<int> *pushI;
				pushI = searchName<int>(listI, name);

				if (pushI == nullptr)												// checks if the list does not exist
				{
					Output << "ERROR: This name does not exist!" << '\n'; 
				} 
				else if (pushI != nullptr)										// pushes onto the list if the list exists
				{
					(*pushI).push(numI);
				}
			}
			else if (name[0] == 'd')							// Again, similar methods used for double and string instances
			{
				double numD = stod(info); 
				SimpleList<double> *pushD;
				pushD = searchName<double>(listD, name);

				if (pushD == nullptr)
				{
					Output << "ERROR: This name does not exist!" << '\n'; 
				} 
				else if (pushD != nullptr)
				{
					(*pushD).push(numD);
				}
			}
			else if (name[0] == 's')
			{
				SimpleList<string> *pushS;
				pushS = searchName<string>(listS, name);

				if (pushS == nullptr)
				{
					Output << "ERROR: This name does not exist!" << '\n'; 
				} 
				else if (pushS != nullptr)
				{
					(*pushS).push(info);
				}
			}
		}
		else if (command == "pop")							// if command is pop, there is no third word
		{
			if (name[0] == 'i')
			{
				SimpleList<int> *popI;
				popI = searchName<int>(listI, name); 

				if (popI == nullptr)											// checks if the list exists
				{
					Output << "ERROR: This name does not exist!" << '\n';
				}
				else if (popI != nullptr)											// checks if the list is empty 
				{
					if (popI->getSize() == 0)
					{
						Output << "ERROR: This list is empty!" << '\n';
					}
					else if (popI->getSize() > 0)
					{
						int iData = (*popI).pop();										// stores the value of the popped item
						Output << "Value popped: " << iData << '\n';
					}
				}

			}
			if (name[0] == 'd')														// Similar methods for double and string instances 
			{
				SimpleList<double> *popD;
				popD = searchName<double>(listD, name); 

				if (popD == nullptr)
				{
					Output << "ERROR: This name does not exist!" << '\n';
				}
				else if (popD != nullptr)
				{
					if (popD->getSize() == 0)
					{
						Output << "ERROR: This list is empty!" << '\n';
					}
					else if (popD->getSize() > 0)
					{
						double dData = (*popD).pop();
						Output << "Value popped: " << dData << '\n';
					}
				}
			}
			if (name[0] == 's')
			{
				SimpleList<string> *popS;
				popS = searchName<string>(listS, name); 

				if (popS == nullptr)
				{
					Output << "ERROR: This name does not exist!" << '\n';
				}
				else if (popS != nullptr)
				{
					if (popS->getSize() == 0)
					{
						Output << "ERROR: This list is empty!" << '\n';
					}
					else if (popS->getSize() > 0)
					{
						string sData = (*popS).pop();
						Output << "Value popped: " << sData << '\n';
					}
				}
			}
		}
	}

	file.close();										// closes both files after reading all the input and outputting all neccessary commands and values
	Output.close();
}

int main()
{	
	string inp, out; 													// takes user input for a file input name, and a file output name
	cout << "Enter the name of an input text file:" << '\n';
	cin >> inp; 
	cout<< "Enter the name of an output text file:" << '\n';
	cin >> out;

	applyOperations(inp, out);											// parses through input file and applies all neccessary commmands 

	return 0;

}