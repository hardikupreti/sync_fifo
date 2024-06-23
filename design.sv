// Code your design here
module fifo_synchronous #(parameter DEPTH=8 ,WIDTH = 8) (input clk,rst_n,w_en,r_en,                                              input [WIDTH-1:0] data_in,output reg [WIDTH-1:0] data_out, output full,empty);
  
  reg [$clog2(DEPTH)-1:0] w_ptr,r_ptr;
  reg [WIDTH-1:0] fifo[DEPTH];
  
  
  //Default Reset Values
  always@(posedge clk) begin
    if(!rst_n) begin
      w_ptr<=0; r_ptr<=0;
      data_out<=0;
      for(int j=0;j<8;j++) begin
        fifo[j]<=0;
      end
    end
    
    else begin 
      	//Write operation
		if(w_en & !full) begin
      		fifo[w_ptr] <= data_in;
          w_ptr<=(w_ptr+1) % DEPTH;
    	end
    	//Read operation
    	if(r_en & !empty) begin
      		data_out<= fifo[r_ptr];
          r_ptr<= (r_ptr+1) % DEPTH;
    	end
  	end
    
  end
  
  assign full = ((w_ptr==3'b111 & r_ptr == 3'b000));
//   assign full = ((w_ptr[3] ^ r_ptr[3]) & (w_ptr == r_ptr));
  assign empty = (r_ptr==w_ptr);
  
endmodule
  
  
  