module DESERIALIZER #(parameter width = 7) (
input	wire						DESER_EN     ,
input	wire						SAMPLED_BIT  ,
input	wire						CLK		  	 ,
input	wire						RST			 ,
input	wire  			[3:0]		BIT_CNT		 ,
input	wire			[width-1:0]	EDGE_CNT 	 ,
input	wire			[width-2:0]	PRESCALE	 ,

output	reg	  			[7:0]		P_DATA
);

///////////////////// internal signals ////////////////////

wire	flag ;

//////////////////// sequential always ////////////////////

always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		P_DATA <= 'b0 ;
	end
	else begin
		if(DESER_EN && flag)
		begin
			case(BIT_CNT)
				4'd1 :	P_DATA[0] <= SAMPLED_BIT ;
				4'd2 :	P_DATA[1] <= SAMPLED_BIT ;
				4'd3 :	P_DATA[2] <= SAMPLED_BIT ;
				4'd4 :	P_DATA[3] <= SAMPLED_BIT ;
				4'd5 :	P_DATA[4] <= SAMPLED_BIT ;
				4'd6 :	P_DATA[5] <= SAMPLED_BIT ;
				4'd7 :	P_DATA[6] <= SAMPLED_BIT ;
				4'd8 :	P_DATA[7] <= SAMPLED_BIT ; 
			endcase
		end
	end
end

assign flag = ( EDGE_CNT == (PRESCALE - 1'b1) ) ;

endmodule
