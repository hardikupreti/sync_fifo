// Code your testbench here
// or browse Examples
module tb_sync_fifo;
  parameter DEPTH = 8;
  parameter WIDTH = 8;
  
  wire [WIDTH-1:0] data_out;
  wire full,empty;
  reg clk,rst_n,w_en,r_en;
  reg [WIDTH-1:0] data_in;
  
  //We need a Queue to push data_in
  
  reg [WIDTH-1:0] data_queue[$], wdata;
  
  fifo_synchronous fifo_instance(clk,rst_n,w_en,r_en,data_in,data_out,full,empty);
  
  
  always #5 clk = ~clk;
  
  // Reset COndition
  initial begin
    clk=0;rst_n=0;w_en=0;data_in=0;
  end
  
  
  
  initial begin
    // Write Operation
    repeat(2) @(posedge clk); //Wait for 10 CLK Cycles
    rst_n=1; //Remove reset signal
    
    repeat(1) begin
      for (int i=0;i<30;i=i+1) begin
        @(posedge clk);
        w_en = (i%2 == 0) ? 1 : 0 ;
        if (w_en & !full) begin
          data_in = $urandom; // data being given to DUT
          data_queue.push_back(data_in); //same data being fed to queu for later comparison
        end
      end  
    end
    
    //Read Operation
    repeat(5) @(posedge clk); //Start reading after 5 CLK Cycles
    
    repeat(1) begin
      for(int i =0;i<30;i++) begin
        @(posedge clk);
        r_en = (i%2 == 0) ? 1: 0;
        if (r_en & !empty) begin
          #1;
          wdata = data_queue.pop_front();
          if(data_out != wdata)
            $error("Time = %0t: Comparison Failed : Expected wrData = %h, received_data = %h",$time,wdata,data_out);
          else
            $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time,wdata,data_out);
        end
      end
    end
    
    $finish();
  end
    

  
  
  
    
    
    
    
    
  
  initial begin
    $dumpfile("sync_fifo_hdk.vcd");
    $dumpvars;
  end
  
endmodule

    
    
    
    
    
  