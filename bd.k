/ ----------------------------------------
/ stuff for my "big data in k" talk 
/ ----------------------------------------

/ some simple functions
fact:{*/1+!x}
avg:{(+/x) % #x}
stdev:{_sqrt mean _sqr x - mean x}

/ tacit style
round: _ 0.5 +
merge: ?,

/ histogram
hist: {+(?x; #:'= x)}       / histogram

/ using / and \
pas: 10{+':0,x,0}\1
fib: 50 {x,+/x}/ 1          / try `fib 5 10`
phi: (1+%:)/1.0

/ ascii graphing
scale: {mx: |/ x; x * % mx}
graph: {`0:" *" @(!100) </: 100 * scale x}

/ a deck of cards
deck: `$,/ "A23456789TJQK" ,/:\: "cdhs"    / all 52 cards
cardc: {fg "GBRKm"@"cdhs"?*|$x}            / card colors
card: {,/(cardc x; $x; bg"k";" ")}         / render card in ansi color
showc: {`6:,/ card'[x], "\n"}              / print a list of cards
showc deck

/ permutations and combinations
hperms: */52-!5
hcombs: hperms % fact 5

C0:{[p;n] fact[p] % fact[p-n] * fact[n]}  / except that theory < practice. see log2 fact[52]
C:{[p;n] (*/n#p-!p) % */1+!n}
hcombs: C[52;5]

/ random hand: mixed base number
hbase: 52-!5
hbase _vs 0
hbase _vs hperms-1
                            rhnum: *_draw[1;hperms]
                  hbase _vs rhnum: *_draw[1;hperms]
do[10;showc deck@ hbase _vs rhnum: *_draw[1;hperms]] `6:fg"w"

/ bits
bits:{(-x) # (x #0), 2 _vs y}
nbits:1|#2_vs

logb: {[b;n] (_log n) % _log b}
log2: logb[2]
nbits:{_ _ceil log2 x+1}



/ string operations (also work on arrays)
cut: {[c;s] 1 _' (&c=s) _ s:c,s}
rpad:{[c;w;s] w#s,w#c}
lpad:{[c;w;s] (-w)#(w#c),s}
join:{[sep;strs] (#sep)_,/sep,/:lpad[" ";5]'$strs}

/ some operations on indices
gfirst: {*:'=x}   / first of each group by unique key
expand: {x@&y}    / {,/ y #' x}


/ == scary internal stuff ==================================

/ csv loader (note: doesn't handle quoted commas)
csv:{[x]                             / csv filename -> dict of columns
  res: .()                           / result is dictionary
  rows: cut[","]' 0:x                / read lines and cut each on ','
  cols: `$ _ssr[;"@cn ";""]' rows 0  / fetch column names
  if[#bad:&~(#cols)=#:'rows          / detect and defend against extra/missing commas
    :err["bad rows"; rows[bad]]]
  typs: `$ _ssr[;"@ct ";""]' rows 1  / fetch column types
  tmap:.((`i;0);(`f;0.0);(`a;`))     / type map for @ct line
  res[cols]: tmap[typs] $'+ 2_ rows  / drop meta rows, transpose rest, convert types, add to tbl.
:res}

/ show a table
from:{[t;pv] if[@pv;pv:,pv] r:.(); r[!t]:t[;pv]; r}
show:{[t] w:11;`0:"\n",,/'w$(,!t),(,(#!t)#,w#"-"),+t[;]}

/ load our data
db: .(); ts: `min`pop`gdp`bud`mil`sol
if[`min _in ts; db.min: csv "data/min.csv"]
if[`pop _in ts; db.pop: csv "data/countries-pop.csv";]
if[`gdp _in ts; db.gdp: csv "data/countries-pop.csv";]
if[`bud _in ts; db.bud: csv "data/countries-bud.csv";]
if[`mil _in ts; db.mil: csv "data/countries-mil.csv";]
if[`sol _in ts; db.sol: csv "data/solar-system.csv";]

/ integer sums that add up to n
bighalf:{(1+x)%2}
MEM:(();,1)
cuts:{
  `0:,/($x;"\n")
  :[x<1; :()]
  :[x<#MEM; :MEM[x]]
  log["t"; t:+(x-i; i:!x)]
  MEM,: res: ,/{x,/:cuts[y]}/'1 _ t
:res}

/ ansi colors
pal:"krgybmcwKRGYBMCW"
c_:{c:*$x; "\33[00;", :[(_ic c)>96;"";"01;"], ($y+(pal?c)!8), "m"}
fg:c_[;30]
bg:c_[;40]
demo:{`6:,/{fg[x],x}'[pal],fg["w"],"\n"}
err:{[msg;data] `0:,/(fg"R";msg;":";fg"r";"\n";5:data;fg"w";"\n")}
log:{[msg;data] `0:,/(fg"G";msg;":";fg"g";"\n";5:data;fg"w";"\n")}
echo:{`0:(5:x),"\n"}


/ timed eval
tms: {[t;src] a:(); do[t;a,: ."\\t ",src]; a}

/ format as decimal
fmt: {s:$x; if[4>#s;:s]; c:(#s)!3; (c#s),,/",",/: -1 3 # c _ s}

/ primes less than n  O(N^2)
plt: {[n] 2 _ & ~(!n) _lin ? ,/{x*/:\:x} @ 2+ ! n%2};


/ == demos =================================================

/ grouping / sorting demo
!db
!db.sol
nm:db.sol.name
tp:db.sol.type
<nm
nm@<nm
=tp
tp@=tp


/ table demos
t: db.sol
show from[t]@  <t.rkm
show from[t]@  <t.vol
show from[t]@  &~t.type=`planet

/ linear regression demo
p: (!15) ^/:\: 0 1 2    / basis polynomial p: 1 + x + x^2
c: 2 3 5                / coefficients
      c */: p           / multiply c by each row of p
  +/' c */: p           / sum each row
   c _dot/: p           / same thing, simplified
y: c _dot/: p           / assign it to y
   y _lsq +p            / 'divide' by +p to (hopefully) get c


ns: 10*-0.5+(#y)_draw 0 / noise
round (y+ns) _lsq +p    / should be close. depends on ns

/ try runing it many times:
i:0;do[10;ns: 10*-0.5+(#y)_draw 0; echo(i+:1; round(y+ns)_lsq+p)]

/ bits of primes less than k...
+ bits[8]' plt 256


/ == end demos, show welcome msg.. =========================
cls:{`6:,//("\33[2J";(fg'"mYRYRrrrrm"),'"[1010data]";fg"W";" Welcome to k.";fg"w";"\n\n")}
cls[];`0:"  "
