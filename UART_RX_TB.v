`timescale 1us/1ps
module UART_RX_TB #(parameter width = 7) ();

reg					clk_tb 	 	;
reg					rst_tb      ;
reg					par_typ_tb  ;
reg					par_en_tb   ;
reg	  [width-2:0]	prescale_tb ;
reg					rx_in_tb	;

wire				parity_error_tb ;
wire				stop_error_tb   ;
wire				data_valid_tb   ;
wire  [width:0]		p_data_tb		;

//////////////////////////////////////////////////////////
////////////////////// DUT SIGNALS ///////////////////////
//////////////////////////////////////////////////////////

UART_RX_TOP DUT (
	.clk(clk_tb),
	.rst(rst_tb),
	.par_typ(par_typ_tb),
	.par_en(par_en_tb),
	.prescale(prescale_tb),
	.rx_in(rx_in_tb),
	.parity_error(parity_error_tb),
	.stop_error(stop_error_tb),
	.data_valid(data_valid_tb),
	.p_data(p_data_tb)
);

//////////////////////////////////////////////////////////
////////////////////// PARAMETERS ////////////////////////
//////////////////////////////////////////////////////////

parameter CLK_PERIOD = 8.68 ;   // 115.2 KHZ

//////////////////////////////////////////////////////////
///////////////////// INITIAL BLOCK //////////////////////
//////////////////////////////////////////////////////////

initial
begin

//intialization task
	intialize();
	
//reset task
	reset();
	
//read_check task

//testing on prescale 8
	read_check (1'b1 , 1'b1 , 11'b10_0111_1111_0 , 8'b0111_1111 , 1) ;			
	read_check (1'b0 , 1'b0 , 11'b10_0111_1011_0 , 8'b0111_1011 , 2) ;
	read_check (1'b0 , 1'b1 , 11'b10_0011_0011_0 , 8'b0011_0011 , 3) ;
	glitch() ;													  		//checking if my design is immune to glitches
	
//testing on prescale 16
	prescale_tb = 6'd16 ;
	read_check (1'b0 , 1'b1 , 11'b10_0011_0011_0 , 8'b0011_0011 , 4) ;
	read_check (1'b1 , 1'b1 , 11'b10_0111_1111_0 , 8'b0111_1111 , 5) ;
	
//testing on prescale 32
	prescale_tb = 6'd32 ;
	read_check (1'b0 , 1'b0 , 11'b10_0101_0101_0 , 8'b0101_0101 , 6) ;
	glitch() ;
	read_check (1'b0 , 1'b0 , 11'b10_1111_1111_0 , 8'b1111_1111 , 7) ;
	read_check (1'b0 , 1'b0 , 11'b00_1110_0110_0 , 8'b1110_0110 , 8) ; 	//checking stop bit error functionality
	read_check (1'b0 , 1'b0 , 11'b10_0101_0101_0 , 8'b0101_0101 , 9) ;
	read_check (1'b1 , 1'b1 , 11'b11_0111_1011_0 , 8'b0111_1011 , 10);  //checking parity error functionality
	read_check (1'b0 , 1'b1 , 11'b10_0011_0011_0 , 8'b0011_0011 , 11);
	
	#(20*CLK_PERIOD) $finish ;											   
end

//////////////////////////////////////////////////////////
///////////////////////// TASKS //////////////////////////
//////////////////////////////////////////////////////////

///////////////////// INTIALIZE TASK /////////////////////
task intialize ;
begin
	prescale_tb = 6'd8 ;
	clk_tb		= 1'b0 ;
	rst_tb 		= 1'b0 ;
	par_typ_tb 	= 1'b0 ;
	par_en_tb 	= 1'b0 ;
	rx_in_tb   	= 1'b1 ;
end
endtask

/////////////////////// RESET TASK //////////////////////

task reset ;
begin
	#CLK_PERIOD rst_tb = 1'b1 ;
	#CLK_PERIOD	rst_tb = 1'b0 ;
	#CLK_PERIOD	rst_tb = 1'b1 ;
end
endtask

//////////////////// READ & CHECK TASK /////////////////

task read_check ;
input	reg					parity_typ    ;
input	reg					parity_enable ;
input	reg		 [10 : 0]	frame  		  ;

input	reg		 [7 : 0]	expected_data ;
input	reg		 [5:0]		k             ;
integer						i 	   		  ;
reg							stop_bit      ;
reg							parity_bit	  ;
begin
	parity_bit = 1'b0 		  ;
	par_typ_tb = parity_typ   ;
	par_en_tb = parity_enable ;
	rx_in_tb = frame[0]		  ;
	#(CLK_PERIOD);
	for(i = 1 ; i < 9 ; i = i + 1)
	begin
		rx_in_tb = frame[i];
		#(CLK_PERIOD) 	   ;
	end
	
	if(par_en_tb)
	begin
		rx_in_tb = frame[9]   ;
		parity_bit = rx_in_tb ;
		#(CLK_PERIOD);
		rx_in_tb = frame[10]  ;
		stop_bit = rx_in_tb   ;
		#(CLK_PERIOD);
	end
	
	else
	begin
		rx_in_tb = frame[10] ;
		stop_bit = rx_in_tb  ;
		#(CLK_PERIOD);
	end
	
	if(stop_bit && !parity_bit)
	begin
		if(expected_data == p_data_tb && data_valid_tb)
		begin
			$display("test case %0d passed , recevied frame = %0b , extracted data = %8b" , k , frame , p_data_tb) ;
		end
	end
	
	else
	begin
		$display("test case %0d UART_RX detected corrupted data succefully" , k) ;
	end
end
endtask


//////////////////////// GLITCH TASK //////////////////////

task glitch ;
begin
	@(negedge clk_tb) ;
	rx_in_tb = 1'b0 ;
	@(negedge clk_tb) ;
	rx_in_tb = 1'b1   ;
	#(CLK_PERIOD) ;
end
endtask


//////////////////////////////////////////////////////////
//////////////////// CLOCK GENERATOR /////////////////////
//////////////////////////////////////////////////////////

always #(CLK_PERIOD/(2*prescale_tb)) clk_tb = ~clk_tb ;

endmodule
