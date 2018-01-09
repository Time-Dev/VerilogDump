module lab4p1 (
A,		// one input
B,		// another input
C,		// yet another input
D,		// another input
G		// an output
);
//  Input ports
input	A;
input 	B;
input 	C;
input	D;
// Output ports
output G;

wire An;
wire Bn;
wire Dn;

wire w,x,y,z,o,p;


not(An,A);
not(Bn,B);
not(Dn,D);
and(w, An, Dn);
and(x,A,B,D);
and(y,Bn,Dn);
and(z,A,C,D);
or(o,w,x);
or(p,y,z);
or(G,o,p);


endmodule

module lab4p1_tb;  // Note, no interface to testbenches
 reg wA,wB,wC,wD;      // signals to be commanded must be "reg"
 wire wG;			// output from unit-under-test is "wire"


initial begin
	wA=0;			// test 000
	wB=0;
	wC=0;
	wD=0;

	#5 	wC=1;		// test 0001
	#5 	wB=1;		// test 0011
	#5 	wC=0;		// test 0010
	#5 	wA=1;		// test 0110
	#5 	wC=1;		// test 0111
	#5 	wB=0;		// test 0101
	#5 	wC=0;		// test 0100
	
	
	#5 	wD=1;		// test 1100
	#5 	wB=1;		// test 1110
	#5 	wA=1;		// test 1111
	#5 	wC=0;		// test 1011
	#5 	wB=0;		// test 1001
	#5 	wC=1;		// test 1101
	#5 	wA=0;		// test 1100
	#5 	wC=0;		// test 1000
	#5 $finish;
end

// Connect UUT to test bench signals
lab4p1 uut(
.A	(wA),
.B	(wB),
.C	(wC),
.Y	(wY)
);
endmodule