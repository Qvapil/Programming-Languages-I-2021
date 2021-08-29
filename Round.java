import java . io .*;
public class Round {
  public static void main(String[] args) {
    try {
      //read file
      BufferedReader in=new BufferedReader(new FileReader(args[0]));
      String line=in.readLine();
      String[] a=line.split(" ");
      int towns=Integer.parseInt(a[0]);
      int cars=Integer.parseInt(a[1]);
      String ar1str=in.readLine();
      in.close();

      String[] ar1spl=ar1str.split(" ");
      //array that stores what town each car is in
      int[] ar1=new int[cars];
      for(int i=0; i<cars; i++) {
        ar1[i]=Integer.parseInt(ar1spl[i]);
      }

      //array that stores how many cars in each town
      int[] ar2=new int[towns];
      //sum of distances of all cars to town 0
      int sum=0;
      //town where the car furthest to 0 is
      int maxp=towns;
      for(int i=0; i<cars; i++) {
        ar2[ar1[i]]++;
        sum+=(towns-ar1[i])%towns;
        if(ar1[i]!=0 && ar1[i]<maxp) {
          maxp=ar1[i];
        }
      }


      //max distance to town 0
      int maxd=(towns-maxp)%towns;
      //final answers
      int minsum=towns*cars;
      int finaltown=0;
      //pointer to iterate through towns
      int townp=0;
      //check if town 0 is valid
      if (sum-maxd+1>=maxd) {
        minsum=sum;
      }

      //check if all cars are in the same town
      for(int i=0; i<towns; i++) {
        if (ar2[i]!=0) {
          finaltown=i;
          townp++;
        }
      }
      //if yes, output town and exit
      if(townp==1) {
        minsum=0;
        System.out.printf("%d %d\n",minsum,finaltown);
        System.exit(0);
      }

      townp=1;
      finaltown=0;
      //iterate for each town
      while(townp<towns) {
        //find the non empty town with max distance to townp (next to the right)
        if((ar2[maxp]==0) || (maxp==townp)) {
          maxp=(maxp+1)%towns;
          continue;
        }
        //find max distance and sum of distances
        //check if max distance is at most 1 more than sum of rest distances
        //if no, solution is invalid cause max distance car has to move twice
        //if solution is valid and sum of distances is smallest yet, update
        maxd=(towns+townp-maxp)%towns;
        sum=sum+cars-towns*ar2[townp];
        if((sum<minsum) && (sum-maxd+1>=maxd)) {
          minsum=sum;
          finaltown=townp;
        }
        townp++;
      }

      System.out.printf("%d %d\n",minsum,finaltown);

    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
}
