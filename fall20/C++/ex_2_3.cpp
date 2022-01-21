#include <iostream>

using namespace std;

// swap two number (call by reference using )
void swap_ref(int &a, int &b)
{
  int t;
  t=a; // memorize a
  a=b; // overwrite a with b
  b=t; // assign memorized a to b
}

// swap two numbers by using pointers
void swap_pointer(int *a, int *b)
{
    int t;
    t=*a;
    *a=*b;
    *b=t;
}


    

int main()
{
    int x,y;
  
    cout << "Two numbers, please: ";
    cin >> x >> y;
    cout << endl;
    cout << "entered numbers are x: " << x << " y: " << y << endl;
    swap_ref(x,y);
    cout << "Swapped once: ";
    cout << "x: " << x << " y: " << y << endl;
    swap_pointer(&x,&y);
    cout << "Swapped twice: ";
    cout << "x: " <<  x << " y: " << y << endl;
    return 0;
}
