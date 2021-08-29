#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
using namespace std;

//recursively checks if neighbouring tiles connect to input tile and updates t
//Parametres:
/*t: bool grid
m,n: coordinates of tile that called
D: maze
M,N: dimensions of maze*/
void neighbours(bool** t, int m, int n, string D[], int M, int N) {
    if(m!=0) {
        if(D[m-1][n]=='D' && t[m-1][n]!=1) {
            t[m-1][n]=1;
            neighbours(t,m-1,n,D,M,N);
        }
    }
    if(m!=M-1) {
        if(D[m+1][n]=='U' && t[m+1][n]!=1) {
            t[m+1][n]=1;
            neighbours(t,m+1,n,D,M,N);
        }
    }
    if(n!=0) {
        if(D[m][n-1]=='R' && t[m][n-1]!=1) {
            t[m][n-1]=1;
            neighbours(t,m,n-1,D,M,N);
        }
    }
    if(n!=N-1) {
        if(D[m][n+1]=='L' && t[m][n+1]!=1) {
            t[m][n+1]=1;
            neighbours(t,m,n+1,D,M,N);
        }
    }
    return;
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

    string D[M];
    for(int i=0; i<M; ++i) {
        getline(infile,D[i]);
    }

    //print maze
    /*cout << M << " " << N << "\n";
    for(int i=0; i<M; ++i) {
        cout << D[i] << '\n';
    }
    cout << '\n';*/

    //creating bool grid to track which tiles you can exit from
    bool **t;
    t = new bool *[M];
    for(int i = 0; i <M; i++)
        t[i] = new bool[N];

    //find upper and lower immediate exits
    //set them to 1
    for(int i=0; i<N; i++) {
        if(D[0][i]=='U') {
            t[0][i]=1;
        }
        if(D[M-1][i]=='D') {
            t[M-1][i]=1;
        }
    }
    //find left and right immediate exits
    //set them to 1
    for(int i=0; i<M; i++) {
        if(D[i][0]=='L') {
            t[i][0]=1;
        }
        if(D[i][N-1]=='R') {
            t[i][N-1]=1;
        }
    }

    //from each immediate exit call function neighbours
    //if you can exit from a tile, if its neighbours lead to it you can exit
    //from them too
    for(int i=0; i<N; i++) {
        if(t[0][i]==1) {
            neighbours(t,0,i,D,M,N);
        }
        if(t[M-1][i]==1) {
            neighbours(t,M-1,i,D,M,N);
        }
    }
    for(int i=0; i<M; i++) {
        if(t[i][0]==1) {
            neighbours(t,i,0,D,M,N);
        }
        if(t[i][N-1]==1) {
            neighbours(t,i,N-1,D,M,N);
        }
    }

    //all tiles you can't exit from have 0, so count them in bad
    int bad=0;
    for(int i=0; i<M; ++i) {
        for(int j=0; j<N; ++j) {
            if(t[i][j]==0) {
                bad++;
            }
        }
    }

    cout << bad << '\n';
}
