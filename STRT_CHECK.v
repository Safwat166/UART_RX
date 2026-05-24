module STRT_CHECK (
input	wire	STRT_CHK_EN ,
input	wire	SAMPLED_BIT ,

output	reg		STRT_GLITCH
);

/////////////////// combinational always //////////////////

always @ (*)
begin
	if(STRT_CHK_EN)
	begin
		if(!SAMPLED_BIT)
		begin
			STRT_GLITCH = 1'b0 ;
		end
		
		else
		begin
			STRT_GLITCH = 1'b1 ;
		end
	end
	
	else
	begin
		STRT_GLITCH = 1'b0 ;
	end
end
endmodule
