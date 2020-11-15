module spi  //ADS1118
(  
	input clk, 
	output SIMO,   //slave input master output （master为FPGA�?
	output SCLK,   //时钟
	input  SOMI,   //slave output master input 
	output reg CS, //片�?�（低电平有效） 
	  
	output [15:0]rddat1 
);

reg [15:0]cnt;
reg start=0; //�?始信�?
wire done;   //结束信号
reg clk_1M;
//wire [15:0] rddat;
//clkdiv div1(clk,clk_1M); //clk分频器模�?
//AD a1(clk_1M,1,start,16'hC2EB,cs,rddat1,done,SIMO,SCLK,SOMI); //调用AD模块�?16'hC2EB为ADS1118控制寄存器寄存器的�?�，1100001011101011
AD AD_inst //调用AD模块�?16'hC2EB为ADS1118控制寄存器寄存器的�?�，1100001011101011
(
	.clk(clk_1M) ,	// input  clk_sig
	.rst_n(1) ,	// input  rst_n_sig
	.go(start) ,	// input  go_sig
	.wrdat(16'hC2EB) ,	// input [15:0] wrdat_sig
	.rddat(rddat1) ,	// output [15:0] rddat_sig
	.ok(done) ,	// output  ok_sig
	.mosi(SIMO) ,	// output  mosi_sig
	.sclk(SCLK) ,	// output  sclk_sig
	.miso(SOMI) 	// input  miso_sig
);

always@(posedge clk_1M)
begin
	if(cnt<=50)
		begin
			cnt<=cnt+1;
			CS<=1'b1;
		end
	else if(cnt>50&&cnt<70) 
	//�?始交换数�?
		begin
			CS<=1'b0; //片�?�置�?
			start<=1; //�?始信号有�?
			cnt<=cnt+1;
		end
	else if(cnt>=70)
		begin
			cnt<=0;
			start<=0;
		end
end


		
reg [23:0]cnt_1M;
always @(posedge clk)
	if(cnt_1M<24'd49)
		cnt_1M<=cnt_1M+1'b1;
	else begin
		cnt_1M<=1'b0;
		clk_1M<=~clk_1M;
	end		
    
	
//end
endmodule