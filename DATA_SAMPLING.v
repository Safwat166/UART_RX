module DATA_SAMPLING #(parameter width = 7) (
input	wire							RX_IN       ,
input	wire							DAT_SAMP_EN ,
input	wire			[width-1:0]		EDGE_CNT    ,
input	wire			[width-2:0]		PRESCALE 	,
input	wire							CLK			,
input	wire							RST         ,

output	reg								SAMPLED_BIT
);

///////////////////// internal signals ////////////////////

wire	[width-3:0]	HALF_PRESCALE ;
reg					SAMPLED_BIT1  ;
reg					SAMPLED_BIT2  ;
reg					SAMPLED_BIT3  ;

/////////////////// sequential always ////////////////////

always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		SAMPLED_BIT1 <= 1'b0 ;
		SAMPLED_BIT2 <= 1'b0 ;
		SAMPLED_BIT3 <= 1'b0 ;
	end
	
	else if (DAT_SAMP_EN)
	begin
		if (EDGE_CNT == (HALF_PRESCALE - 1'd1))
		begin
			SAMPLED_BIT1 <= RX_IN ;
		end
	
		else if (EDGE_CNT == HALF_PRESCALE )
		begin
			SAMPLED_BIT2 <= RX_IN ;
		end
	
		else if (EDGE_CNT == (HALF_PRESCALE + 1'd1))
		begin
			SAMPLED_BIT3 <= RX_IN ;		
		end
	end
	
	else
	begin
		SAMPLED_BIT1 <= 1'b0 ;
		SAMPLED_BIT2 <= 1'b0 ;
		SAMPLED_BIT3 <= 1'b0 ;
	end
	
end

//////////////////// sequential always ///////////////////

always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		SAMPLED_BIT <= 1'b0 ;
	end
	
	else if(DAT_SAMP_EN)
	begin
		case({SAMPLED_BIT1 , SAMPLED_BIT2 , SAMPLED_BIT3})
			3'b000  : SAMPLED_BIT <= 1'b0 ;
			3'b001  : SAMPLED_BIT <= 1'b0 ;
			3'b010  : SAMPLED_BIT <= 1'b0 ;
			3'b011  : SAMPLED_BIT <= 1'b1 ;
			3'b100  : SAMPLED_BIT <= 1'b0 ;
			3'b101  : SAMPLED_BIT <= 1'b1 ;
			3'b110  : SAMPLED_BIT <= 1'b1 ;
			3'b111  : SAMPLED_BIT <= 1'b1 ;		
			default : SAMPLED_BIT <= 1'b0 ;
		endcase
	end
	
	else
	begin
		SAMPLED_BIT <= 1'b0 ;
	end
end

assign HALF_PRESCALE = (PRESCALE >> 1'b1) ;

endmodule
