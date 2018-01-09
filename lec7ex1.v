//
//	Author: Dr. David Foster
//	Last Editted: 2/23/2016
//  
//
//	Purpose: Detect the pattern 101 from an input signal and assert
// 	an output sigal for 1 clock cycle when detected.
//	Inputs:
//		A: input waveform to monitor for the pattern 101
//		CLK: periodioc clock signal
//		RESET: when asserted, forces the system into state S0, works synchronously
//	Outputs:
//		Y: set to 1 for one clock cycle when 101 is detected on the A input
//	Implementation details:
//		The states for the Moore state machince are defined as follows:
//			S0, encoded a 00, represents having seen 0 bits of the sequence - output is 0
//			S1, encoded a 01, represents having seen 1 bit of the sequence - output is 0
//			S2, encoded a 10, represents having seen 2 bits of the sequence - output is 0
//			S3, encoded a 11, represents having seen 3 bits of the sequence - output is 1
//


module lec7ex1 (
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
						// can add or RESET for asynchronous reset
begin
	#2;
	if (RESET == 1) begin
		state = 2'b00;
	end 
	else begin	// This implements the transitions of the state machine
		if (state == 2'b00)	begin		// state where no bits have been found
			if(A == 0) state = 2'b00;
			if(A == 1) state = 2'b01;
		end 
		else if (state == 2'b01) begin // state with 1 _ _ found
			if(A == 0) state = 2'b10;
			if(A == 1) state = 2'b01;
		end 
		else if (state == 2'b10) begin // state with 1 0 _ found	
			if(A == 0) state = 2'b00;
			if(A == 1) state = 2'b11;
		end 
		else if (state == 2'b11) begin // state with 1 0 1 found
			if(A == 0) state = 2'b10;
			if(A == 1) state = 2'b01;	
		end
	end
end

// Moore machine output section
always @ (state) 
begin
	if (state == 2'b00) Y = 0;  // pattern 101 hasn't been detected...
	if (state == 2'b01) Y = 0;
	if (state == 2'b10) Y = 0;
	if (state == 2'b11) Y = 1;  // pattern is found in state 11, assert output
end
	
endmodule

module lec7ex1_tb;  	// Note, no interface to testbenches
 reg wA,wCLK,wRESET;    // signals to be commanded must be "reg"
 wire wY;				// output from unit-under-test is "wire"

 
initial  begin
    $dumpfile ("lec7ex1.vcd"); 
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
lec7ex1 uut(
.A		(wA),
.CLK	(wCLK),
.RESET	(wRESET),
.Y		(wY)
);
endmodule