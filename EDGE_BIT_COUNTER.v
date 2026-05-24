module EDGE_BIT_COUNTER #(parameter width = 7) (
input	wire							ENABLE   ,
input	wire							CLK      ,
input	wire							RST      ,
input	wire			[width-2:0]		PRESCALE ,

output	reg				[3:0]			BIT_CNT  ,
output	reg				[width-1:0]		EDGE_CNT  
);

///////////////////// internal signals ////////////////////

wire	EDGE_CNT_FLAG ;

//////////////////// sequential always ////////////////////

always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		BIT_CNT  <= 4'd0 ;
		EDGE_CNT <= 6'd0 ; 
	end
	
	else if(ENABLE)
	begin
		if (EDGE_CNT_FLAG)
		begin
			EDGE_CNT <= EDGE_CNT + 1'b1 ;
		end
		
		else
		begin
			BIT_CNT <= BIT_CNT + 1'b1 ;
			EDGE_CNT <= 0 ;
		end
	end
	
	else
	begin
		BIT_CNT  <= 4'd0 ;
		EDGE_CNT <= 6'd0 ;
	end
end

assign	EDGE_CNT_FLAG =	(EDGE_CNT != (PRESCALE - 1'b1)) ;

endmodule
