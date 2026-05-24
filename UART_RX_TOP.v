module UART_RX_TOP #(parameter width = 7) (
input	wire					clk      	 ,
input	wire					rst      	 ,
input	wire					par_typ  	 ,
input	wire					par_en   	 ,
input	wire	[width-2:0]		prescale     ,
input	wire					rx_in        ,

output	wire					parity_error ,
output	wire					stop_error   ,
output	wire					data_valid   ,
output	wire	[width:0]		p_data		 
);

//////////////////////////////////////////////////////////
/////////////////// INTERNAL SIGNALS /////////////////////
//////////////////////////////////////////////////////////

wire							dat_samp_en 	;
wire				[width-1:0]	edge_cnt 		;
wire				[3:0]		bit_cnt  		;
wire							enable      	;
wire							deser_en		;
wire							stp_chk_en  	;
wire							strt_glitch 	;
wire							strt_chk_en 	;
wire							par_chk_en  	;
wire							sampled_bit 	;
wire							stop_error_comb ;

/////////////////////////////////////////////////////////
/////////////////////// INSTANTS ////////////////////////
/////////////////////////////////////////////////////////

////////////////////// FSM INSTANT //////////////////////

FSM	F1 (
	.RX_IN(rx_in),
	.PAR_EN(par_en),
	.EDGE_CNT(edge_cnt),
	.BIT_CNT(bit_cnt),
	.STP_ERR(stop_error_comb),
	.STRT_GLITCH(strt_glitch),
	.PAR_ERR(parity_error),
	.CLK(clk),
	.RST(rst),
	.PRESCALE(prescale),
	.DATA_VALID(data_valid),
	.DAT_SAMP_EN(dat_samp_en),
	.ENABLE(enable),
	.DESER_EN(deser_en),
	.STP_CHK_EN(stp_chk_en),
	.STRT_CHK_EN(strt_chk_en),
	.PAR_CHK_EN(par_chk_en)
);

////////////// EDGE BIT COUNTER INSTANT ///////////////

EDGE_BIT_COUNTER E1 (
	.ENABLE(enable),
	.CLK(clk),
	.RST(rst),
	.PRESCALE(prescale),
	.BIT_CNT(bit_cnt),
	.EDGE_CNT(edge_cnt)
);

/////////////// DATA SAMPLING INSTANT ///////////////// 

DATA_SAMPLING S1 (
	.RX_IN(rx_in),
	.DAT_SAMP_EN(dat_samp_en),
	.EDGE_CNT(edge_cnt),
	.PRESCALE(prescale),
	.CLK(clk),
	.RST(rst),
	.SAMPLED_BIT(sampled_bit)
);

//////////////// DESERIALIZER INSTANT /////////////////

DESERIALIZER D1 (
	.DESER_EN(deser_en),
	.SAMPLED_BIT(sampled_bit),
	.CLK(clk),
	.RST(rst),
	.BIT_CNT(bit_cnt),
	.EDGE_CNT(edge_cnt),
	.PRESCALE(prescale),
	.P_DATA(p_data)
);

///////////////// PARITY CHECK INSTANT /////////////////

PARITY_CHECK P1 (
	.CLK(clk),
	.RST(rst),
	.SAMPLED_BIT(sampled_bit),
	.PAR_CHK_EN(par_chk_en),
	.PAR_TYP(par_typ),
	.P_DATA(p_data),
	.PAR_ERR(parity_error)
);

///////////////// STOP CHECK INSTANT /////////////////

STOP_CHECK STP (
	.CLK(clk),
	.RST(rst),
	.SAMPLED_BIT(sampled_bit),
	.STP_CHK_EN(stp_chk_en),
	.PRESCALE(prescale),
	.EDGE_CNT(edge_cnt),
	.STP_ERR_SEQ(stop_error),
	.STP_ERR(stop_error_comb)
);

///////////////// START CHECK INSTANT ////////////////

STRT_CHECK STR (
	.STRT_CHK_EN(strt_chk_en),
	.SAMPLED_BIT(sampled_bit),
	.STRT_GLITCH(strt_glitch)
);

endmodule
