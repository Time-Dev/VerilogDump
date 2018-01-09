//
//	Author: Dr. David Foster
//	Last Editted: 2/23/2016
//  
//
//	Purpose: Arbitrary Mealy machine to show one way to code the output section.


module lec7ex3 (
A,		// serial input signal
CLK,	// clock input
RESET,	// state machine reset
Y		// output signal indicating 101 has been detected
);
//  Input ports
input	A;
input 	CLK;
input	RESET;
// Output ports
output Y;

wire A;
wire CLK;
wire RESET;
reg [1:0] state;
reg Y;

always @ (posedge CLK) // Only positive transition on clock is the sensitivity list
						// can add or posedgeRESET for asynchronous reset
begin
	// #2; // Add propagation delay for state transition logic
	if (RESET == 1) begin
		state = 2'b00;
	end 
	else begin	// This implements the transitions of the state machine
		if (state == 2'b00)	begin		// state where no bits have been found
			if(A == 0) state = 2'b00;
			else state = 2'b01;
		end 
		else if (state == 2'b01) begin // state with 1 _ _ found
			if(A == 0) state = 2'b10;
			else state = 2'b01;
		end 
		else if (state == 2'b10) begin // state with 1 0 _ found	
			if(A == 0) state = 2'b00;
			else state = 2'b11;
		end 
		else if (state == 2'b11) begin // state with 1 0 1 found
			if(A == 0) state = 2'b10;
			else state = 2'b01;	
		end
	end
end

// Mealy machine output section
always @ (state or A) 
begin
	case(state)//#2;  // add propagation delay for CLN generating output
	2'b00: Y = A;  // pattern 101 hasn't been detected...
	2'b01: Y = !A;
	2'b10: Y = 0;
	2'b11: Y = 1;  // pattern is found in state 11, assert output
	endcase
end
	
endmodule

module lec7ex3_tb;  	// Note, no interface to testbenches
 reg wA,wCLK,wRESET;    // signals to be commanded must be "reg"
 wire wY;				// output from unit-under-test is "wire"

 
initial  begin
    $dumpfile ("lec7ex3.vcd"); 
	$dumpvars; 
end 

initial begin
	wRESET = 1;
	wCLK = 0;
	wA = 0;
	#8 wRESET = 0;	// test S00, A=0
	#10 wA = 1;		// test S00, A=1
	#20 wA = 0;		// test S01, A=1, then test S01, A=0
	#10 wA = 1;		// test S10, A=1
	#10 wA = 0;		// test S11, A=0
	#20 wA = 1;		// test S10, A=0
	#10 wA = 0;
	#10 wA = 1;		// test S11, A-1
	#20;
	$finish;
end

always begin
	#5 wCLK =! wCLK;
end

// Connect UUT to test bench signals
lec7ex3 uut(
.A		(wA),
.CLK	(wCLK),
.RESET	(wRESET),
.Y		(wY)
);
endmodule