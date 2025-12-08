pragma circom 2.1.4;

include "./node_modules/circomlib/circuits/multiplexer.circom";
include "./node_modules/circomlib/circuits/comparators.circom";

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

template Pow(n) {
   assert(n >= 1);
 
   signal input a[2];
   signal output out;

   // ensure that a[1] < n
   signal inLTn;
   inLTn <== LessThan(252)([a[1],n]);
   inLTn === 1;

   // precompute powers sequence from 0 to n-1: power[i] = base^i
   signal power[n];

   // compute the powers
   power[0] <== 1; // base^0 = 1
   for (var i=1; i<n; i++){
      power[i] <== power[i-1] * a[0];
   }

   // select the power number of interest
   component mux = multiplexer(1, n);
   mux.sel <== a[1];

   // select the power into the quin selector
   for (var i=0; i<n; i++){
      mux.inp[i][0] <== power[i];
   }

   out <== mux.out[0];
}

component main = Pow();

