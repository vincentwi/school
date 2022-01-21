#include <iostream>
#include <iomanip>

using namespace std;

// a: acceleration
// v: speed
// x0: initial position
// t: time
double position(double a, double v, double x0, double t)
{
    return x0+v*t+1.0/2*a*t*t;
}

int main()
{
    double a,v,x0,dt,t;
    int n,i1;
    
    cout << "Acceleration: ";
    cin >> a;
    cout << a << " ";
    cout << "Initial speed: ";
    cin >> v;
    cout << v << " ";
    cout << "Initial position: ";
    cin >> x0;
    cout << x0 << " ";
    cout << "Number of times: ";
    cin >> n;
    cout << n << " ";
    cout << "Delta t: ";
    cin >> dt;
    cout << dt << " ";
    cout << endl;
    
    for(i1=0,t=0.0;i1<=n;i1++,t+=dt)
    {
        cout << "At time ";
        cout << setw(10) << setprecision(4) << t << " the position is ";
        cout << setw(10) << setprecision(4) << position(a,v,x0,t) << endl;
    }
    return 0;
}
