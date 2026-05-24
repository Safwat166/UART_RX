module STOP_CHECK #(parameter width = 7) (
input	wire						SAMPLED_BIT ,
input	wire						STP_CHK_EN  ,
input	wire			[width-2:0]	PRESCALE    ,
input	wire			[width-1:0]	EDGE_CNT    ,
input	wire						CLK		  	,
input	wire						RST			,

output	reg							STP_ERR_SEQ ,
output	reg							STP_ERR 
);
///////////////////// internal signals ////////////////////

wire	flag 	;

/////////////////// combinational always //////////////////

always @ (*)
begin
	if(STP_CHK_EN && flag)
	begin
		if(SAMPLED_BIT)
		begin
			STP_ERR = 1'b0 ;
		end
		
		else
		begin
			STP_ERR = 1'b1 ;
		end
	end
	
	else
	begin
		STP_ERR = 1'b0 ;
	end
end

//////////////////// sequential always ////////////////////
always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		STP_ERR_SEQ <= 1'b0 ;
	end
	
	else
	begin
		STP_ERR_SEQ <= STP_ERR ;
	end
end

assign flag = (EDGE_CNT == (PRESCALE - 2'd2)) ;

endmodule
