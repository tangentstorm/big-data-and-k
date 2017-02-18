/ ----------------------------------------
/ stuff for my "big data in k" talk 
/ ----------------------------------------

/ some simple functions
fact:{*/1+!x}
avg:{(+/x) % #x}
stdev:{_sqrt mean _sqr x - mean x}
merge:?,

/ histogram
hist: {+(?x; #:'= x)}       / histogram

/ ascii graphing
scale: {mx: |/ x; x * % mx}
graph: {`0:" *" @(!100) </: 100 * scale x}

/ a deck of cards
deck: `$,/ "A23456789TJQK" ,/:\: "cdhs"    / all 52 cards
cardc: {fg "GBRKm"@"cdhs"?*|$x}            / card colors
card: {,/(cardc x; $x; bg"k";" ")}         / render card in ansi color
showc: {`6:,/ card'[x], "\n"}              / print a list of cards
showc deck

/ bits
logb: {[b;n] (_log n) % _log b}
log2: logb[2]
nbits:{_ _ceil log2 x+1}
bits:{(-x) # (x #0), 2 _vs y}

/ grouping / sorting demo
!db
!db.sol
nm:db.sol.name
tp:db.sol.type
<nm
nm@<nm
=tp
tp@=tp



/ string operations (also work on arrays)
cut: {[c;s] 1 _' (&c=s) _ s:c,s}
rpad:{[c;w;s] w#s,w#c}
lpad:{[c;w;s] (-w)#(w#c),s}
join:{[sep;strs] (#sep)_,/sep,/:lpad[" ";5]'$strs}

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


/ operations on indices
group: =
gradu: <
gradn: >
gfirst: {x?/:?x} "hello"  / position of first of each unique
gfirst: {*:'=x}  "hello"  / same thing.
expand: {x@&y}            / {,/ y #' x}

/ timed eval
tms: {[t;src] a:(); do[t;a,: ."\\t ",src]; a}


/ combinations
bad_C:{[p;n] fact[p] % fact[p-n] * fact[n]}  / except that theory < practice. see log2 fact[52]
C:{[p;n] (*/n#p-!p) % */1+!n}

/ format as decimal
fmt: {s:$x; if[4>#s;:s]; c:(#s)!3; (c#s),,/",",/: -1 3 # c _ s}

/ primes less than n  O(N^2)
plt: {[n] 2 _ & ~(!n) _lin ? ,/{x*/:\:x} @ 2+ ! n%2};


/ bits of primes less than k...
+ bits[8]' plt 256


\clear      / clear screen and show our welcome message:.
`6:,//((fg'"mYRYRrrrrm"),'"[1010data]";fg"W";" Welcome to k.";fg"w";"\n\n  ")
