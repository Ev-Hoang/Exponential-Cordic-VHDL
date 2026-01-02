#include <iostream>
#include <cmath>
#include <vector>
#include <limits>

using namespace std;

int main() {
    const int N = 30;
    const double LN2 = log(2.0);

    /* =======================
       RANGE REDUCTION
       t = k*ln2 + r , |r| <= 0.5
    ======================= */
    double t;
    cout << "Enter t: ";
    cin >> t;

    int k = (int)round(t / LN2);
    double r = t - k * LN2;

    /* =======================
       GENERATE ITERATION SEQUENCE
       repeat i = 4,7,10,13,...
    ======================= */
    vector<int> seq;
    for (int i = 1; (int)seq.size() < N; i++) {
        seq.push_back(i);
        if ((i - 1) % 3 == 0 && i > 1) {   // i = 4,7,10,...
            seq.push_back(i);
        }
    }

    /* =======================
       LUT: atanh(2^-i)
    ======================= */
    vector<double> LUT;
    for (int i : seq) {
        LUT.push_back(atanh(pow(2.0, -i)));
        
        cout << "atanh number " << i << " ";
    	cout << atanh(pow(2.0, -i)) << endl;
    }

    /* =======================
       COMPUTE K
       K = sqrt(1 - 2^(-2i))
    ======================= */
    double K = 1.0;
    for (int i : seq) {
        K *= sqrt(1.0 - pow(2.0, -2 * i));
    }

    /* =======================
       INITIALIZATION
    ======================= */
    double X = 1.0 / K;
    double Y = 0.0;
    double Z = r;
    
    cout << " x = " << X << endl;
    cout << " y = " << Y << endl;
    cout << " z = " << Z << endl;

    /* =======================
       HYPERBOLIC CORDIC
    ======================= */
    for (size_t n = 0; n < seq.size(); n++) {
        int i = seq[n];
        double shift = pow(2.0, -i);

        double Xn, Yn, Zn;

        if (Z >= 0) {
            Xn = X + Y * shift;
            Yn = Y + X * shift;
            Zn = Z - LUT[n];
        } else {
            Xn = X - Y * shift;
            Yn = Y - X * shift;
            Zn = Z + LUT[n];
        }

        X = Xn;
        Y = Yn;
        Z = Zn;
        
        cout << " LOOP " << n << endl;
        cout << " x = " << X << endl;
    	cout << " y = " << Y << endl;
   		cout << " z = " << Z << endl;
    }

    /* =======================
       RESULT
       e^t = 2^k * (X + Y)
    ======================= */
    double exp_r = X + Y;
    double exp_t = ldexp(exp_r, k);   // exp_r * 2^k

    cout << "\nCORDIC e^t ˜ " << exp_t << endl;
    cout << "std::exp(t)  = " << exp(t) << endl;
    
    cout << "\nPress Enter to continue...";
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    cin.get();

    return 0;
}

