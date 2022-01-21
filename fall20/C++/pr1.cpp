// Program prints a simple message
#include <iostream>
using namespace std;

int exercise_1(double x, double y, double c_x, double c_y, double r) {   
    if ( (pow(r,2) - (pow((c_x-x),2) + pow((c_y-y),2))) >= 0.0) return 1;
    else return 0;
}

int exercise_2(double x, double v, double a, int n, double t) {
    cout << endl << "Acceleration: " << a << " Initial speed: " << v << " Initial position: " << x << " Number of times: " << n << " Delta t: " << t;
    for (double i = 0; i <= n*t; i += t) {
        cout << endl << "At time " << i << " the position is " << x + (v*i) + ((0.5*a) * pow(i, 2));
    }
    return 0;
}

int exercise_3(int x, int y) {
    int z;
    int *xPtr = &x, *yPtr = &y, *zPtr = &z;
    *zPtr = *yPtr;
    *yPtr = *xPtr;
    *xPtr = *zPtr;
    cout << "x now = " << x << " and y = " << y << endl;
    return 0;
}

int exercise_4(int n) {
    int counter = 1;
    for (int i = 1; i <= n; ++i)
    {
        for (int j = 1; j <= i; ++j)
        {
            cout << counter << " ";
            counter++;
        }
        cout << endl;   
    }
    return 0;
}

int exercise_5(int n) {
    int prev_prev=0, prev=1, fib=1;
    for (int i = 0; i < n; ++i) {
        fib = prev + prev_prev;
        prev_prev = prev;
        prev = fib;
    }
    return fib;
}

int exercise_6(int n) {

    if (n == 1) return 1;
    if (n == 0) return 0;
    return exercise_6(n-1) + exercise_6(n-2);
}


int exercise_7(int a, int n) {
    if (n == 0) return 1;
    return pow(a, n) * exercise_7(a, n-1);
}

int exercise_7_2(int a, double n) {
    if (n == 0.0) return 1;
    if (fmod(n,2.0)==0.0) return exercise_7_2(a, n/2) * exercise_7_2(a, n/2);
    if (fmod(n,2.0)==1.0) return a * exercise_7_2(a, n/2) * exercise_7_2(a, n/2);
    return 0;
}


// function main begins program execution
int main() {
    cout << "Welcome␣to␣C++!" << endl; // prints on screen
    int n;
    double x, v, a, t, y, c_x, c_y, r;
    int* x_swap, y_swap;
     


    //EXERCISE 1
    cout << endl << "1) enter the point's x & y: ";
    cin >> x >> y;
    cout << endl << "enter the circles's x & y then r: ";
    cin >> c_x >> c_y >> r;
    cout << exercise_1(x, y, c_x, c_y, r) << endl;


    //EXERCISE 2
    cout << endl << "2) enter the initial position, the speed and the acceleration: ";
    cin >> x >> v >> a;
    cout << endl << "how many times you want to display the position of the moving body? "; 
    cin >> n;
    cout << endl << "how often (in seconds) you want to update the position of the moving object? ";
    cin >> t;
    exercise_2(x, v, a, n, t);
    
    //EXERCISE 3
    cout << endl << endl << "3) enter the values to swap, x & y: ";
    cin >> x >> y; 
    exercise_3(x, y);


    //EXERCISE 4  
    cout << endl << "4) Input 1 number for floyd's triangle: ";
    cin >> n;
    exercise_4(n);
    

    //EXERCISE 5
    cout << endl << "5) Input 1 number for non recursive fib: ";
    cin >> n;
    cout << exercise_5(n) << endl;
    

    //EXERCISE 6
    cout << endl << "6) Input 1 number for recursive fib: ";
    cin >> n;
    // exercise_6(n);
    cout << exercise_6(n) << endl;
    

    //EXERCISE 7
    cout << endl << "7a) Input numbers for power, a & n: ";
    cin >> a >> n;
    cout << exercise_7(a, n) << endl;

    cout << endl << "7b) Input numbers for power even/odd, a & n: ";
    cin >> a >> n;
    cout << exercise_7(a, n) << endl;





    return 0; // indicates that program ended successfully
}
// end function main



