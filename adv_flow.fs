\ adv_flow.fs  UNFINISHED
\ Glenn G. Chappell
\ 2023-03-25
\
\ For CS 331 Spring 2024
\ Code from 3/25 - Forth: Advanced Flow


\ Array-handling words intsize, alloc-array, print-array, and set-array
\ from alloc.fs. Note that sizei is the number of items in an integer
\ array, not the number of bytes required.

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

