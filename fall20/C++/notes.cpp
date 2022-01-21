/* Notes for C++ 

In C, we have these string classes
\0 : null character (end of string)
\n : new line character
\t : horizontal tab character
\v : vertical tab character 
\’ : single quote character
\" : double quote character

Features of string class:
    internally string are stored as array of char
    all is done transparently: no need to terminate with \0
    string can be enlarged/shrunk dynamically (unlike arrays of char)
    there are several useful functions for operating on string


*/

class Point {
private:
    int x,y;
public:
    Point(int x1, int x2): x{x1}, y{x2} {};
    Point(const Point &p2): x{p2.x}, y{p2.y} {};
    int getX() {return x;}
    int getY() {return y;}
};
void print(Point p) { cout << p.getX() << ", " << p.getY() << endl ;}


class String {
private: 
    char *s; //pointer to the string
    int size; //length
public:
    String(const char *str) { //constructor
        size = strlen(s);
        s = new char[size+1]; //allocate array for the string
        strcpy(s, str);
    }
    String (const String& old str ){ // user−defined copy constructor
        size = old str.size ; // set size of copy
        s = new char[size+1]; // allocate the array where to copy old str
        strcpy (s, old str . s ); // copy the string in the new object
    }
    void change(const char ∗str ) { // change the content of String object
        delete[] s; // free the memory containing old string
        size = strlen ( str ); // set size of new string
        s = new char[size+1]; // allocate memory for new string content
        strcpy (s, str); // copy new string
    }
    ~String() { delete[] s;} //destructor
}; 

class Base {
protected: 
    int m_value;
public:
    Base(int value): m_value(value) {};
    void identify () {std::cout << "I am Base \n";}
};

class Derived: public Base {
public:
    Derived(int value): Base(value) {};
    int getValue() { return m_value;}
    void identify () {
        Base::identify();
        std::cout << "I am Derived \n";
    }
    
};


int main(int argc, char const *argv[])
{
    //Point
    Point p1{10, 15}; // creates a construct point
    Point p2 =p1; //uses deep copy constructer line 26
    p2 = p3; //a shalloq copy assignment (not using the copy constructor)
    
    //String
    String str1("John");
    String *str2 = new String{"Mary"};
    delete str2; //destructor for objected pointed at str2 called here
    
    //Base
    Base base(5);
    base.identify();
    Derived derived(7);
    derived.identify();
    return 0;
} //destructor for str1 called here












