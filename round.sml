(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
fun parse file =
    let
	(* A function to read an integer from specified input. *)
      fun readInt input =
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
	    val M = readInt inStream
      val N = readInt inStream
	    val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
	    fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
	      | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	  (M,N, readInts N [])
    end

(* function to find the distance cars have to travel to all reach town i
 if target town is smaller then loop around
 returns list of distances of each car to town i*)
fun state ([],_,_)=[]
  | state ((h::t),N,i)=
      if h<=i then (i-h)::state(t,N,i)
      else (N+i-h)::state(t,N,i)

(* function that returns maximum and sum on a given list *)
fun maxsumlist []=[0,0]
  | maxsumlist L=
      let
        fun mslist ([],max,sum)=[max,sum]
          | mslist ((h::t),max,sum)=
              if h>max then mslist(t,h,sum+h) else mslist(t,max,sum+h)
      in
        mslist(L,0,0)
      end

(* for each town i, calls state to get distances to said town
  calls maxsumlist for each state to find max and total distance

  a solution is only valid if the car that has to travel the most,
  travels at most 1 more step than the total steps of all other cars,
  otherwise the max car has to move more than once in a row

  for each possible ending town (state) check above constraint,
  and pick the one with the smallest sum distance*)
fun checkall (T,N,i,mindist,mintown)=
      if i<N then
        let
          val s=state(T,N,i)
          val [max,sum]=maxsumlist(s)
        in
          if sum-max+1>=max andalso sum<mindist then
            checkall(T,N,i+1,sum,i)
          else checkall(T,N,i+1,mindist,mintown)
        end
      else [mindist,mintown]


fun solve(N,K,T)=
  let
    val [steps,town]=checkall(T,N,0,N*K,0)
  in
    print((Int.toString(steps))^" "^(Int.toString(town))^"\n")
  end
fun round fileName = solve (parse fileName)
