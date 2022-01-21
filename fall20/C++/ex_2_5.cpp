#include <iostream>

using namespace std;

// calculates nth number of Fibonacci
// main=1: main call from other function
// main=0: call recursive call
int fib(int n, int main)
{
  static int c; // counts number of calls to calculate a Fibonacci number
  int r;

  if(main)
    c=0; // if main call then set to 0
  else
    c++; // otherwise increment

  if(n==0||n==1) // base cases
    {
      if(main)
	cout << "Number of recursive calls is " << c << ".\n";
      return n;
    }
  r=fib(n-1,0)+fib(n-2,0);  // recursion
  if(main) // if main call print number of recursive calls
    cout << "Number of calls is " << c << ".\n";
  return r;
}

int main()
{
  int a,b;

  cout << "The number, please: ";
  cin >> a;
  b=fib(a,1);
  cout << a <<"th Fibonacci number is " << b <<"\n";
  
  return 0;
}
