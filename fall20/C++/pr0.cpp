// Program prints a simple message
#include <iostream>
using namespace std;

int exercise_2(int x, int y) {    
    cout << endl << "Input 2 numbers for exercise_2: "; // prints on screen
    cin >> x >> y;

    cout << x*y << endl;
    return 0;
}

int exercise_3(int a, int b, int c) {
    cout << endl << "Input 2 numbers for exercise_3: "; // prints on screen
    cin >> a >> b;

    c = a%b;
    cout << (c==0) << endl ;
    return 0;
}

int exercise_4(int n) {
    cout << endl << "Input 1 number for exercise_4: "; // prints on screen
    cin >> n;

    while (n>0) {
        cout << "*";
        n--;
    }

    cout << endl;
    return 0;
}

int exercise_5(int num) {
    cout << endl << "Input 1 number for exercise_5: "; // prints on screen
    cin >> num;
    int factorial =1 , i;

    while (i <= num) {
        factorial = factorial * i;
        i++;
    }
    cout << "factorial of " << num << " = " << factorial << endl;
    return 0;
}

int exercise_6() {
    cout << endl << "exercise_6: " << endl; // prints on screen
    int row = 5, col = 5, i=1, j=1;

    while (i <= row) {
        while (j <= col) {
            cout << "*";
            j++;
        }

        cout << endl;
        i++;
        j = 1;
    }   
    cout << endl;


    while (row >= 1) {
        for (int i = 0; i < row; i++) {
            cout << "*";
        }
        cout << endl;
        row--;
    }
    cout << endl;


    while (row <= col) {
        for (int i = 0; i < row; i++) {
            cout << "*";
        }
        cout << endl;
        row++;
    }
    cout << endl;

    return 0;
}


int exercise_8(int no, int epsilon) {
    cout << endl << "Input 1 number for exercise_8: "; // prints on screen
    cin >> no;
    double pi = 0;
    int j = 0;

    while (j <= no) {
        pi = pi + pow(-1.0, j) * (4.0/(2.0 *j + 1.0));
        j++;
    }
    cout << "pi to the " << no << "th approximation = " << pi << endl;


    cout << "Input an epsilon for exercise_8: "; // prints on screen
    cin >> epsilon;

    pi = 0, j=0;
    double prev_pi = 1;
    while (abs(pi - prev_pi) >= epsilon) {
        prev_pi = pi;
        pi = prev_pi + pow(-1.0, j) * (4.0/(2.0 *j + 1.0));
        j++;
        cout << prev_pi << " " << pi << " " << j << " " << abs(pi - prev_pi) << endl;
    }
    cout << "part 2 finished at " << j << "th approximation = " << pi << endl;
    return 0;
}

// 3.14159
// 3.14159
// 148298456
// 3.14159
// 3.14159
// 148298457
// 3.14159
// 3.14159
// 148298458
// 3.14159
// 3.14159


// function main begins program execution
int main() {
    cout << "Welcome␣to␣C++!" << endl; // prints on screen
    int x, y, a, b, c, n, num, no, epsilon;
   
    // exercise_2(x, y);
    // exercise_3(a, b, c);
    // exercise_4(n);
    // exercise_5(num);
    // exercise_6();

    //exercise_7();
    exercise_8(no, epsilon);





    return 0; // indicates that program ended successfully
}
// end function main






















