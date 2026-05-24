module PARITY_CHECK (
input	wire						SAMPLED_BIT  ,
input	wire						PAR_CHK_EN   ,
input	wire						PAR_TYP      ,
input	wire	[7:0]				P_DATA		 ,
input	wire						CLK			 ,
input	wire						RST			 ,

output	reg							PAR_ERR
);

///////////////////// internal signals ////////////////////

wire	even_flag ;
wire	odd_flag  ;

///////////////////// sequential always ///////////////////

always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		PAR_ERR <= 1'b0 ;
	end
	
	else if(PAR_CHK_EN)
	begin
		if(even_flag)
		begin
			PAR_ERR <= 1'b0 ;
		end
		
		else if(odd_flag)
		begin
			PAR_ERR <= 1'b0 ;
		end
		
		else
		begin
			PAR_ERR <= 1'b1 ;
		end
	end
	
	else
	begin
		PAR_ERR <= 0 ;
	end
end

assign	odd_flag   = (PAR_TYP == ^P_DATA) && (!SAMPLED_BIT)  ;
assign	even_flag  = (!PAR_TYP == ^P_DATA) && (!SAMPLED_BIT) ;

endmodule
