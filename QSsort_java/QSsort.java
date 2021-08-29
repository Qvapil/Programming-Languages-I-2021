import java.io.*;
import java.util.ArrayList;
import java.util.HashSet;


public class QSsort {
  public static void main(String[] args) {
    try {
      //read file
      BufferedReader in=new BufferedReader(new FileReader(args[0]));
      String line=in.readLine();
      int N=Integer.parseInt(line);
      line=in.readLine();
      in.close();
      String[] numstr=line.split(" ");
      int[] queue=new int[N];

      for(int i=0; i<N; i++) {
        queue[i]=Integer.parseInt(numstr[i]);
      }

      //check if already sorted
      boolean sorted=true;
      for(int i=0; i<N-1; i++) {
        if(queue[i]>queue[i+1]) {
          sorted=false;
          break;
        }
      }
      // if sorted, print empty and exit
      if(sorted) {
        System.out.println("empty");
        System.exit(0);
      }

      //initially stack is empty and no moves have happened
      int[] stack=new int[0];
      String moves="";
      // int[] stack=new int[2];
      // stack[0]=5; stack[1]=5;
      // //each state stores queue, stack and (shortest) moves to get there
      ZQSstate initial=new ZQSstate(queue,stack,moves);

      //list to check states
      ArrayList<ZQSstate> remaining=new ArrayList<ZQSstate>();
      remaining.add(initial);
      // set to keep visited states
      HashSet<ZQSstate> seen=new HashSet<>();
      seen.add(initial);


      //check states
      while(!remaining.isEmpty()) {
        ZQSstate s=remaining.remove(0);
        if(s.isFinal()) {
          //found solution, print moves
          System.out.printf("%s\n",s.getMoves());
          System.exit(0);
        }
        //get next states from this one and add unvisited ones to list
        for(ZQSstate n: s.next()) {
          if(!seen.contains(n)) {
            remaining.add(n);
            seen.add(n);
          }
        }
      }



    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }

}
