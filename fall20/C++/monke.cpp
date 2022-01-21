#include <iostream>
using namespace std;
 
class IntQueue {
protected:
    int *Q, front, back, nfill, size; //init
     
public:
    //constructor
    IntQueue(int s){
        front = -1;
        back = -1;
        size = s;
        Q = new int[s];
        
        for (int i = 0; i < size; ++i) { Q[i] = 0; }
    }
     
    //cout   
    friend std::ostream& operator<<(std::ostream& out,const IntQueue& intq) {
        out << "IntQueue=[{";
        for (int i = 0; i < intq.size; ++i) {out << intq.Q[i] << ",";}
        out << "}, front: " << intq.front << ", back: " << intq.back 
        << ", nfill: " << intq.nfill << " , size: " << intq.size << "]";
    }
    
    // Copy constructor
    IntQueue(const IntQueue &intq) {
        size = intq.size;
        Q = new int[intq.size];
        front = intq.front;
        back = intq.back;

        for (int i = intq.front; i < intq.back; i++) { Q[i] = intq.Q[i]; }
    }
    
    //empty
    void empty(){ nfill = 0; }

    //reset
    void reset() {
        //could have just recreated a new IntQ but would be malloc
        for (int i = 0; i < size; ++i) { Q[i] = 0; }
        front = -1;
        back = -1;
        nfill = 0; //reset nfill aswell
    }

    //getQ
    int *getQ() { return Q; }
         
    //helper functions
    bool isFull(){
        if(front == 0 && back == size - 1){ return true; }
        if(front == size - 1 && back == size - 1) {return true;}
        else return false;
    }
    bool isEmpty(){
        if(front == -1) { return true; }
        else return false;
    }


    void add(int n){
        if(isFull()){ cout << endl<< "Queue at capacity"; } 
        else {
            if(front == -1) front = 0;
            back++;
            Q[back] = n;
            nfill++;
        }
    }
    
    void remove(){
        int n;
        if(isEmpty()){ cout << "Queue empty" << endl; } 
        else { 
            n = Q[front]; 
            if(front >= back) {
                front = -1;
                back = -1;
            } 
            else { 
                front++; 
                nfill--;
            }
        }
    }

    ~IntQueue() { delete[] Q;}
};


int main()
{
    IntQueue iq1(5);
    cout << iq1 << endl; 
    return 0;
}





// //Exam 1
// #include <iostream>
// #include <vector>

// using namespace std; 

// class IntVector
// {
// private:
//     int size;
//     std::vector<int> v;
// public:
//     IntVector(int n){
//         for (int i = 0; i < n; ++i) {
//             v[i] = 0;
//         }
//     }
//     IntVector(int vec[], int n){
//         for (int i = 0; i < n; ++i) {
//             v[i] = vec[i];
//         }
//     }
//     IntVector (const IntVector& intv ){ // user−defined copy constructor
//         //v(intv.v); // copy the string in the new object
//     }
//     void printvec(const IntVector& intv) {
//         // vector<int>::iterator it;
//         // for (it = intv.v.begin(); it != intv.v.end(); it++) {
//         //     cout << *it << " ";
//         // }
//         for (int a : intv.v)
//             cout << a << " ";
//     }

//     //~IntVector() {delete v;}
    
//     friend ostream& operator<<(ostream& os, const IntVector& intv);
// };

// ostream& operator<<(ostream& os, const IntVector& intv)
// {
//     os << 'size: ' << intv.size << ' and vector: ';
//     return os;
// }


// void examB1(int n) {
//     for (int i = 0; i < n; ++i) {
//         cout << endl;
//         if (n/i == 2) {
//             for (int j = 0; j < n; ++j){ cout << "*"; }
            
//         }
//         else {
//             for (int i = 0; i < n; ++i) {
//                 if (n/i == 2) { cout << "*"; }
//                 else {cout << " ";}
//             }   
//         }
//     }
// }

// class PointVector
// {
// protected:
//     int size;
//     double* v;
// public:
//     PointVector(int n){
//         v = new double[n];
//         size = n;
//     }
//     PointVector(double vec[], int n){
//         v = new double[n];
//         size = n;
//         for (int i = 0; i < n; ++i) { v[i] = vec[i]; }
//     }
//     friend std::ostream& operator<<(std::ostream& out,const PointVector& ptvec) {
//         out << "vector = ";
//         for (int i = 0; i < ptvec.size; ++i) {out << ptvec.v[i];}
//     }

//     void display_max(PointVector ptvec) {
//         double max = ptvec.v[0];
//         int indx = 0;
//         for (int i = 0; i < ptvec.size; i+=2) {
//             if (ptvec.v[i] > max) { 
//                 max = ptvec.v[i]; 
//                 indx = i;
//             }
//         }
//         cout << "the max is: " << ptvec.v[indx] << ", " <<  ptvec.v[indx+1] << endl;
//     }

//     void distances(PointVector ptvec) {
//         double distance = 0;

//         for (int i = 0; i < ptvec.size; i+=2) {

//         }
//     }

//     ~PointVector() { delete[] v; }
    
// };



// int main(int argc, char const *argv[]) {


//     // TEST CONSTRUCTOR AND cout<<
//     // int v1 [] = {1,2,3,4};
//     // IntVector iv1(v1,4);
//     //cout << iv1 << endl;
//     return 0;
// }