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
	output [DATA_WIDTH-1:0] GPIO_INTR,
    output [DATA_WIDTH-1:0] RDATA  
  ); 
  logic [DATA_WIDTH-1:0] t_data;
  logic [DATA_WIDTH-1:0] prev_gpio;
  reg [DATA_WIDTH-1:0] data_ingpio_intr_with_high_mask_seq;
  reg [DATA_WIDTH-1:0] data_dir;
  reg [DATA_WIDTH-1:0] data_out;
  reg [DATA_WIDTH-1:0] INTR_MASK;
  reg [DATA_WIDTH-1:0] INTR_POLARITY;
  reg [DATA_WIDTH-1:0] INTR_STATUS;
  reg [DATA_WIDTH-1:0] INTR_TYPE;
  assign RDATA = t_data;
  assign data_in = GPIO_IN;
  assign GPIO_OUT = GPIO_DIR ? data_out : 'z;
  assign GPIO_INTR = INTR_STATUS & INTR_MASK;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)begin
	   data_out     <= 0;
       data_dir     <= 0;
	   INTR_MASK       <= 0;
	   INTR_POLARITY   <= 0;
	   INTR_STATUS     <= 0;
	   INTR_TYPE       <= 0;
	end
	else begin
      if (WRITE) begin
             if (ADDRESS == 32'h004) data_out         <= WDATA;
        else if (ADDRESS == 32'h008) data_dir         <= WDATA;
	    else if (ADDRESS == 32'h010) INTR_MASK        <= WDATA;
	    else if (ADDRESS == 32'h014) INTR_STATUS      <= WDATA;
	    else if (ADDRESS == 32'h018) INTR_TYPE        <= WDATA;
	    else if (ADDRESS == 32'h01C) INTR_POLARITY    <= WDATA;
      end
      else if (!WRITE) begin
	         if (ADDRESS == 32'h000) t_data     <= data_in;
        else if (ADDRESS == 32'h004) t_data     <= data_out;
        else if (ADDRESS == 32'h008) t_data     <= data_dir;
	    else if (ADDRESS == 32'h010) t_data     <= INTR_MASK;
	    else if (ADDRESS == 32'h014) t_data     <= INTR_STATUS;
	    else if (ADDRESS == 32'h018) t_data     <= INTR_TYPE;
	    else if (ADDRESS == 32'h01C) t_data     <= INTR_POLARITY;
      end
	end
  end  
  always @(posedge clk or negedge rst_n) begin
        prev_gpio <= GPIO_IN;
            for (int i = 0; i < DATA_WIDTH-1; i++) begin
                if (INTR_TYPE[i] == 1'b1) begin
                    // Edge interrupt
                    if (INTR_POLARITY[i]) begin
                        INTR_STATUS[i] <= ~prev_gpio[i] & GPIO_IN[i];  // rising
                    end else begin
                        INTR_STATUS[i] <= prev_gpio[i] & ~GPIO_IN[i];  // falling
                    end
                end else begin
                    // Level interrupt
                    if (INTR_POLARITY[i]) begin
                        INTR_STATUS[i] <= GPIO_IN[i];   // high
                    end else begin
                        INTR_STATUS[i] <= ~GPIO_IN[i];  // low
                    end
                end
		    end
  end
endmodule 
