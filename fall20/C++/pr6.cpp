//pr6

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
} 

class Shape {
private: 
    String color;
    bool filled;
public:
    String defalt = "green";
    Shape(): color(defalt) {};
    Shape(String clr, bool fill):
        color(clr), 
        filled(fill) {}

    //Getters
    String getColor() {return color;}
    bool getFilled() {return filled;}

    //Setters
    String setColor(String clr) {color = clr;}
    bool setFilled(bool fill) {filled = fill;}
    
    //Print
    void print() {cout << color << endl;}

    //to be overriden
    void getArea()
};














