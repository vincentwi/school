#include <iostream>
using namespace std;

double * read_poly(int &n){
  cout << "degree of poly: ";
  cin >> n;
  double * c=new double[n+1];
  for(int i=0;i<=n;i++){
    cout << "coefficient of degree " << i << ": ";
    cin >> c[i];
  }
  return c;
}

void print_poly(double *c, int n){
  int i;
  cout << c[0];
  if(n>0)
    cout << " + ";
  for(i=1;i<n;i++)
    cout << c[i] << "*x^" << i << " + ";
  if(n>0)
    cout << c[n] << "*x^" << i;
  cout << endl;
}



//find the result of the polynomial given a number x
double calculated(double * p1, int &d1, double &x) {
  double result = 0;
  for (int i = 0; i <= d1; ++i) {
    result += p1[i] * pow(x,i);
  }
  cout << result << endl;
  return result;
}

//p1 is a collection of d1+1 double values. c0 + c1(x1)^1 +...+c(x_d1)^d1
double * poli_sum(double * p1, int &d1, double * p2, int &d2, int &dr) {
  double * result = new double[max(d1, d2)];
  dr = max(d1,d2);

  for(int i = 0; i <= dr; ++i){
    if (d1>=i){
      result[i] += p1[i];
    }
    if (d2>=i){
      result[i] += p2[i];
    }
    
  }
  return result;
}

//should add the powers
double * poly_product(double * p1, int d1, double * p2, int d2, int &dr) {
  dr = d1+d2; 
  double * result = new double[dr +1];

  for (int i = 0; i <= d1; ++i)
  {
    for (int j = 0; j <= d2; ++j)
    {
      result[i+j] += (p1[i] * p2[j]);
    }
  }

  return result;
}

int main()
{
  double *p1, * p2, *p3, x;
  int dr;
  int d1, d2;

  cout << "poly 1" << endl;
  p1=read_poly(d1);
  print_poly(p1,d1);

  cout << "poly 2" << endl;
  p2=read_poly(d2);
  print_poly(p2,d2);


  cout << "value for x " << endl;
  cin >> x;
  calculated(p1, d1, x);


  cout << "poly sum" << endl;
  p3= poli_sum(p1, d1, p2, d2, dr);
  print_poly(p3,dr);


  cout << "poly product" << endl;
  p3= poly_product(p1, d1, p2, d2, dr);
  print_poly(p3,dr);
  
  delete[] p1;
  delete[] p2;
  delete[] p3;
  return 0;
}