\ adv_word.fs
\ Glenn G. Chappell
\ 2024-03-27
\
\ For CS 331 Spring 2024
\ Code from Mar 27 - Forth: Advanced Words


cr cr
." This file contains sample code from March 27, 2024," cr
." for the topic 'Forth: Advanced Words'." cr
." It will execute, but it is not intended to do anything" cr
." useful. See the source." cr
cr

\ Size of an integer in bytes
8 constant intsize


\ ***** Three Pieces *****


\ 'create' followed by a word makes a new dictionary entry for the word.
\ The behavior of the word (for now) is to push the address of its
\ dictionary entry.

\ Try:
\   create aa
\   aa .

\ ',' (pronounced "comma"), after making a new word with 'create', adds
\ storage for an integer to the new dictionary entry. Then it pops a
\ value off the data stack and stores it in that storage.

\ Try:
\   create bb
\   42 , 109 ,
\   bb @ .
\   bb intsize + @ .

\ 'does>', after making a new word with 'create', makes new behavior for
\ the word. It words just like ':' (colon), except:
\ - The new word does not need to appear after 'does>'.
\ - The behavior of the new word is to push the address of its
\   dictionary entry, THEN execute the code after 'does>'.

\ Try:
\   create cc
\   does> drop + ;
\   22 33 cc .

\ More info tidbits:
\ (1) 'create', ',', and 'does>' are all legal in a compiled context --
\     that is, inside a ': ... ;' word definition.
\ (2) When using both ',' and 'does>' on the same word, do ',' first.
\ (3) When 'create' is used in a compiled context, say in the definition
\     of a word 'abc', 'create' applies to what follows 'abc' when it is
\     used, not what follows 'create' in the definition of 'abc'.
\ (4) When 'does>' is used in a compiled context, say in the definition
\     of a word 'abc', 'does>' ends the definition of 'abc' and begins
\     the definition of the word it creates (but the ending semicolon is
\     still needed).


\ ***** Making Defining Words *****


\ make-hello
\ Defining word. The defined word prints "Hello" with cr before & after.
: make-hello  ( -- )
  create
does> drop
  cr
  ." Hello!" cr
;

\ Try:
\   make-hello greet
\   greet

\ myconstant
\ Defining word. Same as Forth 'constant'.
: myconstant  { val -- }
  create
  val ,
does>  { word-addr }
  word-addr @
;

\ Try:
\   42 myconstant forty-two
\   forty-two .

\ mystr
\ Defining word. Same as Forth '2constant'.
: mystring  { str-addr str-len -- }
  create
  str-addr , str-len ,
does>  { word-addr }
  word-addr @
  word-addr intsize + @
;

\ Try:
\   s" Hello there!" mystring ht
\   cruht type cr

\ myvariable
\ Defining word. Same as Forth 'variable'.
: myvariable  ( -- )
  create
  0 ,
does>  { addr }
  addr
;

\ Try:
\   myvariable x
\   1234 x !
\   x @ .

\ make-multi-print
\ Defining word. Takes n (integer) and string. Defined word prints the
\ string n times, with cr before & after each.
: make-multi-print  { n str-addr str-len -- }
  n 0 < if
    s" make-multi-print: param < 0" exception throw
  endif
  create
  n ,
  str-addr , str-len ,
does>  { word-addr }
  word-addr @ { n }
  word-addr intsize + @ { str-addr }
  word-addr intsize 2 * + @ { str-len }
  cr
  n 0 ?do
    str-addr str-len type
    cr
  loop
;

\ Try:
\   10 s" Howdy, everyone!" make-multi-print w1
\   w1
\   -10 s" Howdy, everyone!" make-multi-print ww

\ make-multi-print2
\ Defining word. Takes string. Defined word takes n (integer) and prints
\ the string n times, with cr before & after each.
: make-multi-print2  { str-addr str-len -- }
  create
  str-addr , str-len ,
does>  { n word-addr }
  n 0 < if
    s" param < 0" exception throw
  endif
  word-addr @ { str-addr }
  word-addr intsize + @ { str-len }
  cr
  n 0 ?do
    str-addr str-len type
    cr
  loop
;

\ Try:
\   s" Salutations, y'all!" make-multi-print2 w2
\   10 w2
\   -10 w2

