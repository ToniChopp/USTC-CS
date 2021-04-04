#include <set>
#include <queue>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;

int endi[4][4]={0,0,0,0,0,8,7,6,0,5,4,3,0,2,1,0};
int dx[]={0,0,1,-1};
int dy[]={1,-1,0,0};

struct Matrix{
    int m[4][4];
    Matrix(int s[4][4] ){
        for ( int i=1; i<=3; i++ )
            for ( int j=1; j<=3; j++ )
                m[i][j]=s[i][j];
    }
    bool operator<(const Matrix& s) const{
        for ( int i=1; i<=3; i++ )
            for ( int j=1; j<=3; j++ )
                if( m[i][j]!=s.m[i][j] )
                    return m[i][j]<s.m[i][j];
        return 0;
    }
    Matrix(){}
};

struct Point{
    int x, y, h, f, cnt;
    int m[4][4];
    bool operator<(const Point& s) const {
        return f>s.f;
    }
    Point(){}
}sp;

priority_queue<Point> Q;
set<Matrix> S;

bool in(int x, int y){
    return (x>=1 && x<=3 && y>=1 && y<=3 );
}
int bfs(Point po){
    Q.push(po);
    Matrix t1(po.m);
    S.insert(t1);
    int step=-1;
    while( !Q.empty() ){
        Point tmp=Q.top();
        Q.pop();
        Matrix t2(tmp.m);
        if( step!=-1 && tmp.cnt>step ) continue;
        if( tmp.h==0 ) step=tmp.cnt;
        if( tmp.cnt>105 ) return -1;
        for ( int i=0; i<4; i++ ){
            Point tp=tmp;
            tp.x=tmp.x+dx[i], tp.y=tmp.y+dy[i];
            tp.cnt=tmp.cnt+1;
            if( in(tp.x,tp.y) ){
                int cnt=0;
                swap( tp.m[tp.x][tp.y], tp.m[tmp.x][tmp.y] );
                for ( int i=1; i<=3; i++ )
                    for ( int j=1; j<=3; j++ )
                        if( tp.m[i][j]!=endi[i][j] ) cnt++;
                tp.h=cnt;
                tp.f=tp.h+tp.cnt;
                Matrix t3(tp.m);
                if( S.find(t3)==S.end() ){
                    S.insert(t3);
                    Q.push(tp);
                }
            }
        }
    }
    return step;
}
int main(){
    int z=0;
    for ( int i=1; i<=3; i++ )
        for ( int j=1; j<=3; j++ ){
            scanf("%1d", &sp.m[i][j] );
            if( !sp.m[i][j] ) sp.x=i, sp.y=j;
            else if( sp.m[i][j]!=endi[i][j] ) z++;
        }
    sp.h=sp.f=z;
    sp.cnt=0;
    printf("%d", bfs(sp) );
    return 0; 
}
