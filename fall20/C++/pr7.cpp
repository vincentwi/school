//pr7 
//vincent
#include <iostream>
#include <exception> 
#include <vector>
#ifndef pr7
#define pr7

using namespace std; 


//Part 1
/*
Patient: Mary
systolic diastolic day
94        61       2/5/2013
97        65       3/5/2013
144       99       4/5/2013
123       88       5/5/2013
177       110      6/5/2013
145       89       7/5/2013

Patient: John
systolic diastolic day
88       57       15/5/2013
95       61       16/5/2013
114      80       17/5/2013
151      96       18/5/2013
176      104      19/5/2013
176      110      20/5/2013
*/

class Date
{ //created seperately for peace of mind
    private: 
        int day, month, year;
    public:
        Date(){ day = month = year = 1; } //default constructor
        Date(int input_day, int input_month, int input_year) { //inputs
            day = input_day;
            month = input_month;
            year = input_year;
        }

        int get_day() { return day; }
        int get_month() { return month; }
        int get_year() { return year; }

        //~Date();
};

class Blood
{ //created seperately for peace of mind
    protected: 
        int systolic, diastolic;
        Date date;
    public:
        Blood(int sys, int dias, Date d){ //inputs
            systolic = sys; 
            diastolic = dias;
            date = d;
        } //used for print method below
        int get_systolic() { return systolic; }
        int get_diastolic() { return diastolic; }
        Date show_date() { return date; } 

        //~Blood();
};


class Patient
{
    protected:
        string patient_name;
        std::vector<Blood> system;
    public:
        Patient(string input_name) { patient_name = input_name; } //input
        void addRecord(Blood input_blood) { system.push_back(input_blood); } //https://www.cplusplus.com/reference/vector/vector/push_back/
        void printReport() {  /* 
            • the highest abnormal systolic blood pressures, together with the corresponding diastolic value, and the day it has been measured;
            • if all systolic values were below 140, “no measurement was too high”;
            • the average diastolic blood pressure;
            • the list (possibly containing a single element) of pressure records for a patient whose systolic pressure is maximal. */
            int highest_abnormal_systolic_blood_pressure = 0, total = 0, diastolic_value = 0, index = 0, THRESHOLD = 140;
            double avg_dialostic_blood_pressure;
            bool report = false;

            cout << "\n**************************************** \nPrinting report for " << patient_name << endl;
            for (int i = 0; i < system.size(); ++i) {
                total += system[i].get_diastolic(); //summing to be used later for avg

                if (system[i].get_systolic() >= highest_abnormal_systolic_blood_pressure){ //if we have a new high
                    highest_abnormal_systolic_blood_pressure = system[i].get_systolic(); //redefine the high
                    index = i; //to be used later for max index
                }
                if (system[i].get_systolic() >= THRESHOLD) {
                    cout << "abnormal systolic blood pressure detected on " << endl;
                    report = true; //flip the switch
                    cout << system[i].show_date().get_day() << " / " << system[i].show_date().get_month() << " / " 
                    << system[i].show_date().get_year() << " Systolic: " << system[i].get_systolic() <<  
                    ", Diastolic: " << system[i].get_diastolic() << endl << endl;
                }
            }

            if (not report) { cout << "no measurement was too high" << endl; } //if we didnt switch
            avg_dialostic_blood_pressure = total/system.size(); //calc avg
            cout << "Average diastolic pressure : " << avg_dialostic_blood_pressure << endl; 
            cout << "Maximal systolic pressure: " << system[index].get_systolic() << endl;
            cout << "Maximal diastolic pressure: " << system[index].get_diastolic() << endl << "\n**************************************** ";

        }
        //~Patient();
    
};



//Part 2


template <typename T>
class StackI
{
    public: //https://www.geeksforgeeks.org/virtual-function-cpp/
        virtual void push(T t) = 0; 
        virtual void pop() = 0;
        virtual T top() = 0;
        virtual bool isEmpty() = 0;
        virtual void print() = 0;
};

//creating an exception for when the stack is overloaded
class FullStackException: public exception{
        const char * what() const throw(){
            return "stack overloaded";
        }
} FullStackException;

//creating an exception for when the stack is empty 
class EmptyStackException: public exception{
        const char * what() const throw(){
            return "stack is empty";
        }
} EmptyStackException;

//making a stack with template
template <typename T> 
class Stack: public StackI<T>{
    protected:
        T *stack;
        int first; //where in the stack (to start)  
        int LENGTH; //The length of the stack as it gets updated
        int SIZE; // The size of the stack defined by the user 
        
    public:
        Stack(){ //default
            stack = new T[10];
            first = 0, LENGTH = 0, SIZE = 10;
        }
        Stack(int n){ //input
            stack = new T[n]; //creating a stack defined by input
            first = 0, LENGTH = 0, SIZE = n;
        }
        ~Stack(){ delete [] stack; } //should delete automatically at the end of program

        //functions
        bool isEmpty(){ return LENGTH == 0; } //check if empty
        void push(T t){
            if(LENGTH >= SIZE){ throw FullStackException; } //if full
            stack[first++] = t; //add number to the top
            LENGTH++; //make the "size" larger
        }
        void pop(){
            if(isEmpty()){ throw EmptyStackException; } //if empty
            first--; //now go one back
            SIZE--; //and make the "size" smaller
        }
        T top(){
            if(isEmpty()){ throw EmptyStackException; } //if empty
            return stack[first]; //whats on top 
        }
        void print(){
            cout << "Printing Stack" << endl;
            if(isEmpty()){ throw EmptyStackException; }
            for(int i = first-1; i >= 0; i--){ cout << stack[i] << endl; } //print in reverse order
        }
};




#endif
int main(int argc, char const *argv[]){
    //Exercise 1
    cout << "Starting Exercise 1: " << endl;
    Patient mary("Mary");
    mary.addRecord(Blood(94,61, Date(2,5,2013)));
    mary.addRecord(Blood(97,65, Date(3,5,2013)));
    mary.addRecord(Blood(144,99, Date(4,5,2013)));
    mary.addRecord(Blood(123,88, Date(5,5,2013)));
    mary.addRecord(Blood(177,110, Date(6,5,2013)));
    mary.addRecord(Blood(145,89, Date(7,5,2013)));
    mary.printReport();

    Patient john("John");
    john.addRecord(Blood(88,57, Date(15,5,2013)));
    john.addRecord(Blood(95,61, Date(16,5,2013)));
    john.addRecord(Blood(114,80, Date(17,5,2013)));
    john.addRecord(Blood(151,96, Date(18,5,2013)));
    john.addRecord(Blood(176,104, Date(19,5,2013)));
    john.addRecord(Blood(176,110, Date(20,5,2013)));
    john.printReport();


    //Exercise 2
    cout << "\n \n \nStarting Exercise 2: " << endl;
    Stack<int> s (25);
    s.push(12);
    s.push(19);
    s.pop();
    s.push(1);
    s.print();
    return 0;
}