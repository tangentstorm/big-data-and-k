
pm:{x,-x}                     / plus or minus
sqrt:_sqrt                    / %: in ok

pn:{[p;x] +/p*x^!#p}          / polynomial with coefficients c

qf:{[c;b;a]                   / quadratic formula
  %[- b - pm sqrt[(b^2)-*/4,a,c]; 2*a]}


/ --- let's do some algebra in k! ----

q0:{[c;b;a]                   / this is just a derivation. no point actualy calling it except maybe to print/debug

    / convert to traditional notation, so we can move individual pieces around.
         +/(c,b,a) * x^!3         / same as pn, but de-vectorized
         +/(c,b,a) * x^0 1 2      / eval !3
         +/(c,b,a) * 1,x^1 2      / x^0 is 1
         +/(c,b,a) * 1,x,x^2      / x^1 is x
         +/(c,b,a) * 1,x,x^2      / x^1 is x
         +/c,(b,a) * x,x^2        / factor out c*1
         c +/(b,a) * x,x^2        / over (f/) allows initial value on left
         c +/(b*x) ,  a*x^2      / dyads (*) distribute over lists
         c + (b*x) +  a*x^2      / over (f/) inserts dyad (+) between items

                   0 = c + (b*x) + a*x^2               / now set to 0 and solve for x
                   0 = (c%a)+(b*x%a) + x^2             / divide by a
              (-c%a) =       (b*x%a) + x^2             / subtract c%a
 (((b%2*a)^2) - c%a) = ((b%2*a)^2) + (b*x%a) + x^2     / add ((b%2*a)^2) to both sides, "completing the square"


         sq:{x^2}                      / helper to let us put ^2 on the left

 (((b%2*a)^2) - c%a) = ((b%2*a)^2) + (b*x%a) + x^2  / same as before
   (sq[b%2*a] - c%a) = sq[b%2*a] + (b*x%a) + x^2    / rewrite with `sq to remove some parens
  =[ sq[b%2*a] - c%a ; sq[b%2*a] + (b*x%a) + x^2 ]  / better yet: factor out (=)
  =[ sq[b%2*a] - c%a ; sq[x+b%2*a] ]                / payoff for completing the square
  =[ (sq[b]%4*a*a) - c%a   ; sq[x+b%2*a] ]          / apply sq to %2a on left
                                                    / sq[m%n] -> (m*m)%(n*n) -> sq[m] % sq[n]

  =[ (sq[b]%4*a*a) - 4*a*c % 4*a*a; sq[x+b%2*a] ]   / multiply c%a by (4*a)%(4*a)
  =[ (sq[b]-4*a*c) % 4*a*a; sq[x+b%2*a] ]           / factor out common denominator

    pm:{x,-x}                     / plus or minus
    sqrt:_sqrt                    / %: in ok

  =[ (sq[b]-4*a*c) % 4*a*a; sq[x+b%2*a] ]           / prev step.
  =[  pm sqrt (sq[b]-4*a*c) % 4*a*a;  x+b%2*a ]     / square root of both sides
  =[  pm sqrt[sq[b]-4*a*c] % 2*a;  x+b%2*a ]        / ! apply sqrt to denominator
  =[ %[pm sqrt[sq[b]-4*a*c]; 2*a]; x + %[b;2*a ]]   / factor out % on both sides
  =[ %[(-b) + pm sqrt[sq[b]-4*a*c]; 2*a]; x ]       /  subtract  %[b;2*a ]
  =[ x ; %[(-b) + pm sqrt[sq[b]-4*a*c]; 2*a]]       /  and we're done, but let's clean up...

    x = %[(-b) + pm sqrt[(b^2)-*/4,a,c]; 2*a]       /  inline =, sq[], factor out some *
    x = %[- b - pm sqrt[(b^2)-*/4,a,c]; 2*a]        /  factor out the - 

}

/ so in the end...

qf:{[c;b;a]  %[- b - pm sqrt[(b^2)-*/4,a,c]; 2*a]}



