#include <iostream>

#include <cmath>

using namespace std;

// computes the distance between two points
double distance(int x1, int y1, int x2, int y2){
    return sqrt(pow(x1-x2,2)+pow(y1-y2,2));
}


// determine wether the point (x,y) is contained in the circle
// with center (xc,yc) and radius r
bool inCircle(int x, int y, int xc, int yc, double r)
{
    if(distance(x,y,xc,yc)<r)
        return true;
    else
        return false;
}

int main()
{
    int x,y,xc,yc;
    double r;
    cout << "enter point co-ordinates: " ;
    cin >> x >> y;
    cout << endl << "enter circle center co-ordinates: " ;
    cin >> xc >> yc;
    cout << endl << "enter circle radius: " ;
    cin >> r;
    
    
    if(inCircle(x,y,xc,yc,r)){
        cout << "(" << x << "," << y << ") is in circle with center (" << xc << "," << yc << ") and radius " << r << endl;
    }
    else{
        cout << "(" << x << "," << y << ") is NOT in circle with center (" << xc << "," << yc << ") and radius " << r << endl;
    }
    
    return 0;
}
