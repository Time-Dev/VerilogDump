module lec6ex1 (
A,		// one input
B,		// another input
C,		// yet another input
Y		// an output
);
//  Input ports
input	A;
input 	B;
input 	C;
// Output ports
output Y;

wire A;
wire B;
wire C;
wire AB;
wire BC;
wire Y;

and (AB,A,B);
and (BC,B,C);
or  (Y,AB,BC);

endmodule

module lec6ex1_tb;  // Note, no interface to testbenches
 reg wA,wB,wC;      // signals to be commanded must be "reg"
 wire wY;			// output from unit-under-test is "wire"


initial begin
	wA=0;			// test 000
	wB=0;
	wC=0;

	#5 	wC=1;		// test 001
	#5 	wB=1;		// test 011
	#5 	wC=0;		// test 010
	#5 	wA=1;		// test 110
	#5 	wC=1;		// test 111
	#5 	wB=0;		// test 101
	#5 	wC=0;		// test 100
	#5 $finish;
end

// Connect UUT to test bench signals
lec6ex1 uut(
.A	(wA),
.B	(wB),
.C	(wC),
.Y	(wY)
);
endmodule