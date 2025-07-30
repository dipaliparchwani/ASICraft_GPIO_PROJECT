// Code your testbench here

// or browse Examples

module GPIO

  #( parameter ADDR_WIDTH = 32,

     parameter DATA_WIDTH = 32 ) (

    input clk,

    input rst_n,

    input [ADDR_WIDTH-1:0]  ADDRESS,

	input                   WRITE,

	input [DATA_WIDTH-1:0]  WDATA,

	input [DATA_WIDTH-1:0]  GPIO_IN,

	input [DATA_WIDTH-1:0]  GPIO_DIR,

    output [DATA_WIDTH-1:0] GPIO_OUT,

    output [DATA_WIDTH-1:0] RDATA  

  ); 

  logic [DATA_WIDTH-1:0] t_data;

  reg [DATA_WIDTH-1:0] data_in;

  reg [DATA_WIDTH-1:0] data_dir;

  reg [DATA_WIDTH-1:0] data_out;
 
  

  always @(negedge rst_n) begin

    data_out     <= 0;

    data_dir     <= 0;

  end
 
  assign RDATA = t_data;

  assign data_in = GPIO_IN;

  assign GPIO_OUT = data_out;

  always @(posedge clk) begin

    if (WRITE) begin

           if (ADDRESS == 32'h004) data_out    <= WDATA;

      else if (ADDRESS == 32'h008) data_dir    <= WDATA;

    end

    else if (!WRITE) begin

	       if (ADDRESS == 32'h000) t_data     <= data_in;

      else if (ADDRESS == 32'h004) t_data     <= data_out;

      else if (ADDRESS == 32'h008) t_data     <= data_dir;

    end

  end  
 
endmodule
 
