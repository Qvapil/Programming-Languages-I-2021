(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
fun parse file =
  let
    fun readInt input =  Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    val inStream = TextIO.openIn file
    val N = readInt inStream
    val M = readInt inStream
  	val _ = TextIO.inputLine inStream

    fun readLines acc =
      case TextIO.inputLine inStream of
        NONE => rev acc
      | SOME line => readLines(explode(String.substring(line,0,M))::acc)

    val inputList=readLines []:char list list
    val _= TextIO.closeIn inStream
  in
    (N,M,inputList)
  end

(*traverses border of maze and marks immediate exits with 1*)
fun findexits (A,N,M) =
  let
    fun findtopexits (A,M,i) =
      (if i<M then
        (if Array2.sub(A,0,i)= #"U" then (Array2.update(A,0,i,#"1"); findtopexits(A,M,i+1))
        else findtopexits(A,M,i+1))
      else A)

    fun findbotexits (A,M,N,i) =
      (if i<M then
        (if Array2.sub(A,N-1,i)= #"D" then (Array2.update(A,N-1,i,#"1"); findbotexits(A,M,N,i+1))
        else findbotexits(A,M,N,i+1))
      else A)

    fun findleftexits (A,N,i) =
      (if i<N then
        (if Array2.sub(A,i,0)= #"L" then (Array2.update(A,i,0,#"1"); findleftexits(A,N,i+1))
        else findleftexits(A,N,i+1))
      else A)

    fun findrightexits (A,M,N,i) =
      (if i<N then
        (if Array2.sub(A,i,M-1)= #"R" then (Array2.update(A,i,M-1,#"1"); findrightexits(A,M,N,i+1))
        else findrightexits(A,M,N,i+1))
      else A)
  in
    (findtopexits(A,M,0); findbotexits(A,M,N,0); findleftexits(A,N,0); findrightexits(A,M,N,0))
  end

(*checks if neighbouring tiles lead to this one
If yes, marks with 1 and calls neighbours from there*)
(*I haven't found a prettier way to write the if statements*)
fun neighbours (A,N,M,0,0) =
      if Array2.sub(A,0,1)= #"L"
      then (Array2.update(A,0,1,#"1"); neighbours(A,N,M,0,1); neighbours(A,N,M,0,0))
      else if Array2.sub(A,1,0)= #"U"
      then (Array2.update(A,1,0,#"1"); neighbours(A,N,M,1,0))
      else A
  | neighbours(A,N,M,0,j) =
      if j=M-1
      then (
        if Array2.sub(A,0,M-2)= #"R"
        then (Array2.update(A,0,M-2,#"1"); neighbours(A,N,M,0,M-2);neighbours(A,N,M,0,j))
        else if Array2.sub(A,1,j)= #"U"
        then (Array2.update(A,1,j,#"1"); neighbours(A,N,M,1,j))
        else A
        )
      else if Array2.sub(A,0,j+1)= #"L"
      then (Array2.update(A,0,j+1,#"1"); neighbours(A,N,M,0,j+1); neighbours(A,N,M,0,j))
      else if Array2.sub(A,1,j)= #"U"
      then (Array2.update(A,1,j,#"1"); neighbours(A,N,M,1,j); neighbours(A,N,M,0,j))
      else if Array2.sub(A,0,j-1)= #"R"
      then (Array2.update(A,0,j-1,#"1"); neighbours(A,N,M,0,j-1))
      else A
  | neighbours(A,N,M,i,0) =
      if i=N-1
      then (
        if Array2.sub(A,i,1)= #"L"
        then (Array2.update(A,i,1,#"1"); neighbours(A,N,M,i,1); neighbours(A,N,M,i,0))
        else if Array2.sub(A,i-1,0)= #"D"
        then (Array2.update(A,i-1,0,#"1"); neighbours(A,N,M,i-1,0))
        else A
        )
      else if Array2.sub(A,i,1)= #"L"
      then (Array2.update(A,i,1,#"1"); neighbours(A,N,M,i,1); neighbours(A,N,M,i,0))
      else if Array2.sub(A,i+1,0)= #"U"
      then (Array2.update(A,i+1,0,#"1"); neighbours(A,N,M,i+1,0); neighbours(A,N,M,i,0))
      else if Array2.sub(A,i-1,0)= #"D"
      then (Array2.update(A,i-1,0,#"1"); neighbours(A,N,M,i-1,0))
      else A
  | neighbours(A,N,M,i,j) =
    if i=N-1 andalso j=M-1
    then (
      if Array2.sub(A,N-2,M-1)= #"D"
      then (Array2.update(A,N-2,M-1,#"1"); neighbours(A,N,M,N-2,M-1); neighbours(A,N,M,i,j))
      else if Array2.sub(A,N-1,M-2)= #"R"
      then (Array2.update(A,N-1,M-2,#"1"); neighbours(A,N,M,N-1,M-2))
      else A
    )
    else if i=N-1
    then (
      if Array2.sub(A,i,j+1)= #"L"
      then (Array2.update(A,i,j+1,#"1"); neighbours(A,N,M,i,j+1); neighbours(A,N,M,i,j))
      else if Array2.sub(A,i,j-1)= #"R"
      then (Array2.update(A,i,j-1,#"1"); neighbours(A,N,M,i,j-1); neighbours(A,N,M,i,j))
      else if Array2.sub(A,i-1,j)= #"D"
      then (Array2.update(A,i-1,j,#"1"); neighbours(A,N,M,i-1,j))
      else A
    )
    else if j=M-1
    then (
      if Array2.sub(A,i+1,j)= #"U"
      then (Array2.update(A,i+1,j,#"1"); neighbours(A,N,M,i+1,j); neighbours(A,N,M,i,j))
      else if Array2.sub(A,i,j-1)= #"R"
      then (Array2.update(A,i,j-1,#"1"); neighbours(A,N,M,i,j-1); neighbours(A,N,M,i,j))
      else if Array2.sub(A,i-1,j)= #"D"
      then (Array2.update(A,i-1,j,#"1"); neighbours(A,N,M,i-1,j))
      else A
    )
    else (
        if Array2.sub(A,i+1,j)= #"U"
        then (Array2.update(A,i+1,j,#"1"); neighbours(A,N,M,i+1,j); neighbours(A,N,M,i,j))
        else if Array2.sub(A,i,j+1)= #"L"
        then (Array2.update(A,i,j+1,#"1"); neighbours(A,N,M,i,j+1); neighbours(A,N,M,i,j))
        else if Array2.sub(A,i,j-1)= #"R"
        then (Array2.update(A,i,j-1,#"1"); neighbours(A,N,M,i,j-1); neighbours(A,N,M,i,j))
        else if Array2.sub(A,i-1,j)= #"D"
        then (Array2.update(A,i-1,j,#"1"); neighbours(A,N,M,i-1,j))
        else A
    )

(*checks the borders and calls neighbours from every immediate exit*)
fun checkborders (A,N,M)=
  let
    fun checktop(A,N,M,j) =
      if j<M then
        (if Array2.sub(A,0,j)= #"1" then (neighbours(A,N,M,0,j); checktop(A,N,M,j+1))
        else checktop(A,N,M,j+1))
        else A

    fun checkbot (A,N,M,i) =
      if i<M then
        (if Array2.sub(A,N-1,i)= #"1" then (neighbours(A,N,M,N-1,i); checkbot(A,N,M,i+1))
        else checkbot(A,N,M,i+1))
      else A

    fun checkleft (A,N,M,i) =
      (if i<N then
        (if Array2.sub(A,i,0)= #"1" then (neighbours(A,N,M,i,0); checkleft(A,N,M,i+1))
        else checkleft(A,N,M,i+1))
      else A)

    fun checkright (A,N,M,i) =
      (if i<N then
        (if Array2.sub(A,i,M-1)= #"1" then (neighbours(A,N,M,i,M-1); checkright(A,N,M,i+1))
        else checkright(A,N,M,i+1))
      else A)

  in
    (checktop(A,N,M,0); checkright(A,N,M,0); checkleft(A,N,M,0); checkbot(A,N,M,0))
  end

(*counts tiles that aren't 1
you can't escape from these*)
fun zeros (A,N,M,i) =
  let
    fun zerosrow (A,N,M,r,j) =
      if j<M then (
        if Array2.sub(A,r,j)<> #"1"
        then 1+zerosrow(A,N,M,r,j+1)
        else zerosrow(A,N,M,r,j+1))
        else 0
  in
    if i<N then zerosrow(A,N,M,i,0)+zeros(A,N,M,i+1) else 0
  end

fun solve(N,M,L)=print(Int.toString(zeros(checkborders(findexits(Array2.fromList(L),N,M),N,M),N,M,0))^"\n")
(*fun solve (N,M,L)=(N,M,Array2.column(checkborders(findexits(Array2.fromList(L),N,M),N,M),2))*)
(*fun solve (N,M,L)=(N,M,Array2.column(neighbours(findexits(Array2.fromList(L),N,M),N,M,N-2,M-1),2))*)
fun loop_rooms fileName = solve (parse fileName)
