\ alloc.fs  UNFINISHED
\ Glenn G. Chappell
\ 2024-03-22
\
\ For CS 331 Spring 2024
\ Code from 3/22 - Forth: Allocation & Arrays


cr cr
." This file contains sample code from March 22, 2024," cr
." for the topic 'Forth: Allocation & Arrays'." cr
." It will execute, but it is not intended to do anything" cr
." useful. See the source." cr
cr


\ intsize
\ Assumed size of integer (bytes)
: intsize 8 ;


\ alloc-array
\ Allocates an array holding the given number of integers. Throws
\ exception on allocation fail.
: alloc-array  { sizei -- addr }
  sizei intsize * allocate throw { addr }
  addr      \ Return our array
;


\ print-array
\ Prints items in given integer array, all on one line, blank-separated,
\ ending with newline.
: print-array  { addr sizei -- }
  sizei 0 ?do
      i intsize * addr + @ .
  loop
  cr
;


\ set-array
\ Sets values in given array. Array starts at addr and holds sizei
\ integers. Item 0 is set to start, item 1 to start+step, item 2 to
\ start+2*step, etc.
: set-array  { start step addr sizei -- }
  start { val }
  sizei 0 ?do
    val i intsize * addr + !
    val step + to val
  loop
;


\ copy
\ Utility memory-copy word. Like C++ std::copy. Copies memory starting
\ at first1, with last1 pointing to just past end. Copies to memory
\ starting at first2, which must point to sufficient allocated memory.
\ The two ranges must not overlap.
: copy  { first1 last1 first2 -- }
  first1 { in }
  first2 { out }
  begin
    in last1 < while
    in @ out !
    in intsize + to in
    out intsize + to out
  repeat
;


\ stable-merge
\ Stable merge of two sorted ranges of integers. First range in
\ [first, middle), second range in [middle, last). On return,
\ [first, last) is sorted. Throws exception 1 on allocation fail.
: stable-merge  { first middle last -- }
  first { in1 }
  middle { in2 }
  last first - { sizeb }
  sizeb allocate throw { buffer }
  buffer { out }
  begin
    in1 middle < in2 last < and while
    in2 @ in1 @ < if
      in2 @ out !
      in2 intsize + to in2
    else
      in1 @ out !
      in1 intsize + to in1
    endif
    out intsize + to out
  repeat

  in1 middle out copy  \ Copy remainder of values to buffer
  in2 last out copy    \  (one of these two lines does nothing)

  buffer buffer sizeb + first copy
                       \ Copy buffer back to original memory
  buffer free throw
;


\ merge-sort-recurse
\ Workhorse function for Merge Sort. Sorted range of integers in
\ [first, last). Throws exception 1 on allocation fail.
: merge-sort-recurse  { first last -- }
  last first - intsize / { sizei }
  sizei 1 > if  \ Base case (nothing to do) if sizei <= 1
    sizei 2 / intsize * first + { middle }
                                    \ Get ptr to middle of range
    first middle recurse            \ Sort 1st half
    middle last recurse             \ Sort 2nd half
    first middle last stable-merge  \ Merge the halves
  endif
;


\ merge-sort
\ Sorts array of integers starting at addr, holding sizei items.
\ Throws exception 1 on allocation fail. Throws exception 2 on bad array
\ size.
: merge-sort  { addr sizei -- }
  sizei 0 < if
    2 throw  \ Throw exception 2 on negative array size
  endif
  sizei intsize * addr + { last }
  addr last merge-sort-recurse
;


\ user-pause
\ Wait for ENTER.
: user-pause  ( -- )
  0 { buffsizeb }
  buffsizeb allocate throw { buff }
  buff buffsizeb accept drop  \ We don't care how many chars were read.
  buff free throw
  ;


\ do-merge-sort
\ Call merge-sort. Prints initial array, sorts, waits for user, prints
\ sorted array.
: do-merge-sort  { sizei -- }
  cr cr ." Array size: " sizei . cr
  sizei alloc-array { arr }
  sizei 2 / 1 - -2 arr sizei 2 / set-array
  sizei 2 / -2 arr sizei 2 / intsize * + sizei sizei 2 / - set-array
  cr ." Values before sort:" cr
  arr sizei print-array
  cr ." Press ENTER to continue " user-pause cr
  cr ." Sorting (Merge Sort) ... "
  stdout flush-file throw  \ Flush standard output
  arr sizei merge-sort
  ." DONE" cr
  cr ." Values after sort:" cr
  arr sizei print-array
  arr free throw
;

\ Try:
\   20 do-merge-sort
\   200000 do-merge-sort

