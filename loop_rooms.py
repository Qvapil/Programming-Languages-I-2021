from sys import argv

#open and parse file
#M,N are 2 integers: number of rows and columns
#maze is a list of strings
with open(argv[1]) as f:
    M,N=map(int,(f.readline()).split())
    maze=[x.strip() for x in f.readlines()]

#find left and right immediate exits, mark them with '1'
#find up and down immediate exits, mark them with '1'
#maze is now a 2d list
maze=[['1' if ((c=='L'and j==0) or (c=='R' and j==N-1)) else c for j,c in enumerate(row)] for row in maze]
maze=[['1' if c=='U' else c for c in row] if i==0 else ['1' if c=='D' else c for c in row] if i==M-1 else row for i,row in enumerate(maze)]

#function that checks the path starting from grid[r][c]
#follows the path and stores each passing tile in set current
#all tiles in current set to '2'
#if an exit '1' is reached set all tiles in path to '1'
#if a loop '0' is reached or loop on self '2' then set all tiles in path to '0'
def path(grid,r,c):
    #set of tiles in path starting from grid[r][c]
    current=set()
    while 1:
        #add tile to path
        current.add((r,c))

        if grid[r][c]=='L':
            if grid[r][c-1]=='1':
                for a in current:
                    grid[a[0]][a[1]]='1'
                return
            elif grid[r][c-1]=='2' or grid[r][c-1]=='0':
                for a in current:
                    grid[a[0]][a[1]]='0'
                return
            else:
                grid[r][c]='2'
                c=c-1

        elif grid[r][c]=='R':
            if grid[r][c+1]=='1':
                for a in current:
                    grid[a[0]][a[1]]='1'
                return
            elif grid[r][c+1]=='2' or grid[r][c+1]=='0':
                for a in current:
                    grid[a[0]][a[1]]='0'
                return
            else:
                grid[r][c]='2'
                c=c+1

        elif grid[r][c]=='U':
            if grid[r-1][c]=='1':
                for a in current:
                    grid[a[0]][a[1]]='1'
                return
            elif grid[r-1][c]=='2' or grid[r-1][c]=='0':
                for a in current:
                    grid[a[0]][a[1]]='0'
                return
            else:
                grid[r][c]='2'
                r=r-1

        elif grid[r][c]=='D':
            if grid[r+1][c]=='1':
                for a in current:
                    grid[a[0]][a[1]]='1'
                return
            elif grid[r+1][c]=='2' or grid[r+1][c]=='0':
                for a in current:
                    grid[a[0]][a[1]]='0'
                return
            else:
                grid[r][c]='2'
                r=r+1

        #return immediately if grid[r][c] is already '0' or '1'
        else:
            return

#call path for every tile
for i in range(M):
    for j in range(N):
        path(maze,i,j)

#count all '0'
looprooms=sum(row.count('0') for row in maze)

print(looprooms)
