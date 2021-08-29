from sys import argv
from collections import deque

#open and parse file
with open(argv[1]) as f:
    M=int(f.readline())
    queue=[int(x) for x in (f.readline()).split()]

solved=False

#initial state is our input queue, empty stack, and empty moves
init=tuple(queue),(),""
#sorting queue to compare later
final=tuple(sorted(queue))

#set that keeps track of states we have visited
#only keep queue and stack
prev={(init[0],init[1])}

#yields states that state s can change into with one move
def next(s):
    #booleans to check what move we can do
    qq,ss= False, False

    #Q move
    if s[0]!=():  #check if queue is empty
        i=1
        for x in s[0][:-1]:
            if s[0][i]==s[0][i-1]:
                i+=1
            else: break
        qqueue=(s[0])[i:]
        qstack=(s[0])[:i]+s[1]
        qmoves=s[2]+i*"Q"
        qq=True

    #S move
    if s[1]!=():  #check if stack is empty
        i=1
        for x in s[1][:-1]:
            if s[1][i]==s[1][i-1]:
                i+=1
            else: break
        sstack=(s[1])[i:]
        squeue=s[0]+(s[1])[:i]
        smoves=s[2]+i*"S"
        ss=True

    if qq and ss:
        yield (qqueue,qstack,qmoves),(squeue,sstack,smoves)
    elif qq:
        yield (qqueue,qstack,qmoves),init
    else:
        yield (squeue,sstack,smoves),init


#deque of states we visit
Q=deque([init])

while Q:
    s=Q.popleft()
    if s[0]==final:
        solved=True
        break
    for t in next(s):
        for a in t:
            if (a[0],a[1]) not in prev:
                Q.append(a)
                prev.add((a[0],a[1]))

if solved:
    if s[2]=="":
        print('empty')
    else:
        print(s[2])
