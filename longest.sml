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
   	(M,N, readInts M [])
    end

(*modifies list so that problem becomes "find longest non negative subarray"*)
fun modifylist (l,v)=
    if null l then nil
    else (~1)*(hd l) -v :: modifylist(tl l,v);

(*returns suffix sum array of input array a
element i of cumsum array is the sum of all elements in a with index bigger than i*)
fun cumsum (a,i,M,sum,ret) =
  if i<M
  then (Array.update(ret,M-1-i,sum+Array.sub(a,M-1-i)); cumsum(a,i+1,M,sum+Array.sub(a,M-1-i),ret))
  else ret

fun max (a,b) = if a>b then a else b;

(*binary search in array arr*)
fun binsearch(arr,l,r,k,ret) =
  let
    val mid = (l+r) div 2
  in
    if r<l then ret
    else if Array.sub(arr,mid)-k>=0
    then binsearch(arr,l,mid-1,k,mid)
    else binsearch(arr,mid+1,r,k,ret)
  end

(*I made this based on this C++ code:
//https://www.geeksforgeeks.org/longest-subarray-with-sum-greater-than-equal-to-zero/
Sa stores an ascending subsequence of elements in sums
Ind stores the index of said element in sums*)
fun findlongest (sums,i,j,Sa,Ind,M,maxdist) =
      if i<M then (
        if j=0 orelse Array.sub(sums,i)>Array.sub(Sa,j-1)
        then (Array.update(Sa,j,Array.sub(sums,i)); Array.update(Ind,j,i);
          if binsearch(Sa,0,j,Array.sub(sums,i+1),~1)> ~1
          then findlongest(sums,i+1,j+1,Sa,Ind,M,max(maxdist,i+1-Array.sub(Ind,binsearch(Sa,0,j,Array.sub(sums,i+1),~1))))
          else findlongest(sums,i+1,j+1,Sa,Ind,M,maxdist))

        else if binsearch(Sa,0,j-1,Array.sub(sums,i+1),~1)> ~1
             then findlongest(sums,i+1,j,Sa,Ind,M,max(maxdist,i+1-Array.sub(Ind,binsearch(Sa,0,j-1,Array.sub(sums,i+1),~1))))
             else findlongest(sums,i+1,j,Sa,Ind,M,maxdist))
      else max(0,maxdist)

fun solve (M,N,D)= print(Int.toString(findlongest(cumsum(Array.fromList(modifylist(D,N)),0,M,0,Array.array(M+1,0)),0,0,Array.array(M,0),Array.array(M,0),M,~1))^"\n")
(*fun solve(M,N,D)=cumsum(Array.fromList(modifylist(D,N)),0,M,0,Array.array(M+1,0))*)
fun longest fileName = solve (parse fileName)
