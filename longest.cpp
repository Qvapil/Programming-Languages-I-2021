#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
using namespace std;

int findlongest(int D[], int M) {

    //calculate prefix sum array
    int sums[M];
    sums[0]=D[0];
    for(int i=1; i<M; ++i) {
        sums[i]=sums[i-1]+D[i];
    }

    //problem is now equivalent to "find largest j-i such that sums[j]>=sums[i]"
    //O(n) solution found here:
    //https://www.geeksforgeeks.org/given-an-array-arr-find-the-maximum-j-i-such-that-arrj-arri/

    //Lmin[i] stores the minimum value of sums up to index i
    int Lmin[M];
    Lmin[0]=sums[0];
    for(int i=0; i<M; ++i) {
        Lmin[i]=min(sums[i],Lmin[i-1]);
    }
    //Rmax[i] stores the maximum value of sums after index i-1
    int Rmax[M];
    Rmax[M-1]=sums[M-1];
    for (int i=M-2; i>=0; --i) {
        Rmax[i]=max(sums[i],Rmax[i+1]);
   }

   //Traverse both arrays to find maximum j-i such that Rmax[j]>Lmin[i]
   int maxdist=-1, i=0, j=0;
   while(j<M && i<M) {
       if(Lmin[i]<=Rmax[j]) {
           maxdist=max(maxdist,j-i);
           j++;
       } else {
           i++;
       }
   }

   //Code has issues when the first element is part of the longest subarray
   //this fixes it
   int startmax=0;
   if (Lmin[0]<=Rmax[0] && Lmin[0]>=0) {
       int j=0;
       while(j<M) {
           if(Lmin[0]<=Rmax[j]) {
               startmax=max(startmax,j);
               j++;
           }
           else {break;}
       }
   } else {
       startmax=-1;
   }

   return max(maxdist,startmax+1);
}

int main(int argc, char** argv) {
    //open file
    ifstream infile;
    infile.open(argv[1]);
    if(!infile) {
        cout << "Error opening " << argv[1] << "\n";
        exit(-1);
    }

    //get data from file
    int M=0, N=0;
    string str;
    stringstream ss(str);

    getline(infile, str, ' ');
    ss<<str;
    ss>>M;
    ss.str("");
    ss.clear();

    getline(infile,str);
    ss<<str;
    ss>>N;
    ss.str("");
    ss.clear();

    //the problem is equivalent to "find longest subarray with sum>=0"
    //by tweaking D as follows
    int D[M];
    for(int i=0; i<M; i++) {
        getline(infile, str, ' ');
        ss<<str;
        ss>>D[i];
        D[i]=-D[i]-N;
        ss.str("");
        ss.clear();
    }

    /*for(int i=0; i<M; i++) {
        cout << D[i] << " ";
    }
    cout << "\n";*/

    cout << findlongest(D,M) << "\n";
    return 0;

}
