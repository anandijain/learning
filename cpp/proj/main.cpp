#include <iostream>
#include <string>
// #include "side.h"

using namespace std;

struct Node {
    Person p;
    struct Node* next;
}

class Person{
    private:
        string id;
    public:
        string name;
        string major;
        float gpa;

        Person(string aName, string aMajor, float aGPA){
            name = aName;
            major = aMajor;
            gpa = aGPA;
            
        }
};


string writePerson(Person p, bool printPerson)
{
    // printName ? (cout << name << endl) : ;

    if (printPerson)
    {
        cout << p.name << endl;
        cout << p.major << endl;
        cout << p.gpa << endl;
    }
    return p.name;
}

int main(int argc, char *argv[])
{
    if (argc % 3 != 1){

        cout << argc << endl;
        cout << "num of args must be multiple of 3 w remainder 1" << endl;
        return 0;
    } else if (argc == 1)
    {
        Person Anand = Person("Anand", "Computer Science", 2.7);
        writePerson(Anand, true);
        return 0;
    }
    
    // Person[] people;
    bool tf = true;
    for (int i = 3; i < argc; i+= 3){
        
        // i % 2 == 0 ? tf = true : tf = false;
         
        Person p = Person(argv[i-2], argv[i-1], std::stof(argv[i]));
        
        writePerson(p, tf);
        if (i + 3 > argc){
            break;
        }
        
    }
    return 0;
}

