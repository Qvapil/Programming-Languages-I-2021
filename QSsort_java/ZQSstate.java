import java.util.ArrayList;
import java.util.Arrays;
import java.util.Objects;

public class ZQSstate {
  //class of state, has queue, stack, and shortest moves to get here
  private int[] queue;
  private int[] stack;
  private String moves;

  //constructor
  public ZQSstate(int[] q, int[] s, String m) {
    queue=q;
    stack=s;
    moves=m;
  }

  //getters
  public String getMoves() {
    return moves;
  }
  public int[] getQueue() {
    return queue;
  }
  public int[] getStack() {
    return stack;
  }

  //check if final state (empty stack and sorted queue)
  public boolean isFinal() {
    if(stack.length!=0) {
      return false;
    }
    for(int i=0; i<queue.length-1; i++) {
      if(queue[i]>queue[i+1]) {
        return false;
      }
    }
    return true;
  }

  //returns list of next states
  public ArrayList<ZQSstate> next() {
    ArrayList<ZQSstate> states= new ArrayList<>();
    // Q move
    if(queue.length!=0) {
      StringBuilder str=new StringBuilder();
      str.append(moves);
      //if same elements do consecutive Q moves
      //n stores number of consecutive moves
      int same=queue[0];
      int n=0;
      while(n<queue.length && queue[n]==same) {
        n++;
        str.append("Q");
      }
      //new queue will have n less elements
      //new stack has n more elements
      int[] q2=new int[queue.length-n];
      int[] s2=new int[stack.length+n];
      //make new queue by removing the n first elements
      for(int i=0; i<q2.length; i++) {
        q2[i]=queue[i+n];
      }
      //make new stack by adding n same elements at the beginning
      for(int i=0; i<n; i++) {
        s2[i]=same;
      }
      for(int i=n; i<s2.length; i++) {
        s2[i]=stack[i-n];
      }
      states.add(new ZQSstate(q2,s2,str.toString()));
    }
    // S move
    if(stack.length!=0) {
      StringBuilder str=new StringBuilder();
      str.append(moves);
      //if same elements do consecutive Q moves
      //n stores number of consecutive moves
      int same=stack[0];
      int n=0;
      while(n<stack.length && stack[n]==same) {
        n++;
        str.append("S");
      }
      //new queue will have n more elements
      //new stack has n fewer elements
      int[] q2=new int[queue.length+n];
      int[] s2=new int[stack.length-n];
      //make new stack by removing the n first elements
      for(int i=0; i<s2.length; i++) {
        s2[i]=stack[i+n];
      }
      //make new queue by adding n same elements at the end
      for(int i=0; i<queue.length; i++) {
        q2[i]=queue[i];
      }
      for(int i=queue.length; i<q2.length; i++) {
        q2[i]=same;
      }
      states.add(new ZQSstate(q2,s2,str.toString()));
    }
    return states;
  }

  //override =
  @Override
  public boolean equals(Object o) {
    //same reference, true
    if(this==o) {
      return true;
    }
    //different class, false
    if(o==null || getClass()!=o.getClass()) {
      return false;
    }
    ZQSstate other=(ZQSstate) o;

    //check queue sizes, if different then false
    if(queue.length!=(other.getQueue()).length) {
      return false;
    }
    //check stack sizes, if different then false
    if(stack.length!=(other.getStack()).length) {
      return false;
    }

    //compare queues, if different then false
    if(!Arrays.equals(queue,other.getQueue())) {
      return false;
    }
    //compare stacks, if different then false
    return Arrays.equals(stack,other.getStack());
  }

  //override hash to ignore moves
  @Override
  public int hashCode() {
    return ((91*Arrays.hashCode(queue)+37)*17+Arrays.hashCode(stack));
  }

}
