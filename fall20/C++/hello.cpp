#include <iostream>
using namespace std;

int power(int base_num, int power_num) {
    int result = 1;

    for (int i=0; i<power_num; i++) {
        result = result * base_num;
    }

    return result;
}

int linked_list() {
    int number_grid[3][2] = {
                            {1, 2},
                            {3, 4},
                            {5, 6}
                            };
    for (int i = 0; i < 3; ++i)
    {
        for (int j = 0; j < 2; ++j)
        {
            cout << number_grid[i][j];
        }
        cout << endl;
    }

    return 0;
}

int pointer() {
    int age = 19;
    double gpa = 2.7;
    string name = "Mike";

    cout << &age << &name;
    return 0;
}

int main() {
    cout << pointer();
    return 0;
}
















