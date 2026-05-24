module FSM #(parameter width = 7) (
input	wire						RX_IN       ,
input	wire						PAR_EN      ,
input	wire			[width-1:0]	EDGE_CNT    ,
input	wire			[3:0]		BIT_CNT     ,
input	wire						STP_ERR     ,
input	wire						STRT_GLITCH ,
input	wire						PAR_ERR     ,
input	wire						CLK			,
input	wire						RST         ,
input	wire			[width-2:0]	PRESCALE	,

output	reg							DATA_VALID  ,
output  reg							DAT_SAMP_EN ,
output	reg							ENABLE      ,
output	reg							DESER_EN    ,
output	reg							STP_CHK_EN  ,
output	reg							STRT_CHK_EN ,
output	reg							PAR_CHK_EN  
);

//////////////////// internal signal /////////////////////

wire	flag ;

//////////////////////// states ///////////////////////// 

typedef enum bit [4:0] {
	IDLE  	 = 5'b00000 ,
	START 	 = 5'b00001 ,
	DATA  	 = 5'b00010 ,
	PAR   	 = 5'b00100 ,
	STOP  	 = 5'b01000 ,
	AVALABLE = 5'b10000 
}state_e;

state_e current_state , next_state ;

/////////////////// state transition ////////////////////

always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		current_state <= IDLE ;
	end
	
	else
	begin
		current_state <= next_state ;
	end
end

/////////////////// next_state logic ////////////////////

always @ (*)
begin
	DATA_VALID	 = 1'b0 ;
	DAT_SAMP_EN  = 1'b0 ;
	ENABLE		 = 1'b0 ;
	DESER_EN 	 = 1'b0 ;
	STP_CHK_EN 	 = 1'b0 ;
	STRT_CHK_EN  = 1'b0 ;
	PAR_CHK_EN	 = 1'b0 ;
	case(current_state)
		IDLE : begin
			if (!RX_IN)
			begin
				next_state = START ;
			end
			
			else
			begin
				next_state = IDLE ;
			end
		end
		
		START : begin
			DAT_SAMP_EN = 1'b1 ;
			ENABLE      = 1'b1 ;
			STRT_CHK_EN = 1'b1 ;
			
			if(flag)
			begin
				if (STRT_GLITCH)
				begin
					next_state = IDLE ;
				end
			
				else
				begin
					next_state = DATA ;
				end
			end
			
			else 
			begin
				next_state = START ;
			end
			
		end
		
		DATA : begin
			DAT_SAMP_EN = 1'b1 ;
			ENABLE      = 1'b1 ;
			DESER_EN    = 1'b1 ;
			
			if(BIT_CNT == 4'd8 && PAR_EN && flag)
			begin
				next_state = PAR ;
			end
			
			else if(BIT_CNT == 4'd8 && !PAR_EN && flag)
			begin
				next_state = STOP ;
			end
			
			else
			begin
				next_state = DATA ;
			end
		end
		
		PAR  : begin
			DAT_SAMP_EN = 1'b1 ;
			ENABLE      = 1'b1 ;
			PAR_CHK_EN  = 1'b1 ;
			
			if(flag)
			begin
				if(PAR_ERR)
				begin
					next_state = IDLE ;
				end
			
				else
				begin
					next_state = STOP ;
				end	
			end
			
			else
			begin
				next_state = PAR ;
			end
		end
		
		STOP : begin
			DAT_SAMP_EN	 	 = 1'b1 ;
			ENABLE      	 = 1'b1 ;
			STP_CHK_EN  	 = 1'b1 ;
			
			if(EDGE_CNT == (PRESCALE - 2'd2))
			begin
				if(STP_ERR)
				begin
					next_state = IDLE ;
				end
			
				else 
				begin
					next_state = AVALABLE ;
				end
			end
			
			else 
			begin
				next_state = STOP ;
			end
		end
		
		AVALABLE : begin
			DATA_VALID = 1'b1 ;
			
			if(!RX_IN)
			begin				
				next_state = START ;
			end							
			
			else
			begin
				next_state = IDLE ;
			end
		end
		
		default : begin
			next_state	 = IDLE ;
			DATA_VALID	 = 1'b0 ;
			DAT_SAMP_EN  = 1'b0 ;
			ENABLE		 = 1'b0 ;
			DESER_EN 	 = 1'b0 ;
			STP_CHK_EN 	 = 1'b0 ;
			STRT_CHK_EN  = 1'b0 ;
			PAR_CHK_EN	 = 1'b0 ;
		end
	endcase
end

/*////////////////////////////////////////////////////////////////////////
- flag : to indicate the last positive edge before the new bit arrives .

- i made this flag because the output of the start check and parity check 
  and stop check should be out after oversampling process.
*/////////////////////////////////////////////////////////////////////////

assign flag = ( EDGE_CNT == (PRESCALE - 1'b1) ) ;


endmodule
