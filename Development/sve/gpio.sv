module GPIO #(
  DATA_WIDTH = 32,
      ADDRESS_WIDTH =32
 
      )(

  input  logic                  clk,
  input  logic                  rst_n,
  // Register interface
  input  logic                  WRITE,
  input  logic [ADDRESS_WIDTH-1:0]            ADDRESS,
  input  logic [DATA_WIDTH-1 :0]           WDATA,
  output logic [DATA_WIDTH-1 :0]           RDATA,
  // External interrupt inputs and output pin
  input  logic [DATA_WIDTH-1:0]          GPIO_IN,
      input  logic [DATA_WIDTH-1:0]          GPIO_DIR,
  output logic [DATA_WIDTH-1:0]          GPIO_OUT,
      output  logic [DATA_WIDTH-1:0]         GPIO_INTR
 
      );

  // Internal wires to/from DUT
reg [DATA_WIDTH-1:0] data_in;

 
reg [DATA_WIDTH-1:0] INTR_STATUS;

 

   // Register storage
logic [DATA_WIDTH-1:0] prev_gpio;
logic [DATA_WIDTH-1:0] data_dir_reg;
logic [DATA_WIDTH-1:0] data_out_reg;
logic [DATA_WIDTH-1:0] INTR_MASK_REG;
logic [DATA_WIDTH-1:0] INTR_POLARITY_REG;
logic [DATA_WIDTH-1:0] INTR_TYPE_REG;
  // Drive inputs to DUT
  assign data_in         = !rst_n ? '0 : data_dir_reg ? data_in : GPIO_IN;

  assign GPIO_OUT        = !rst_n ? '0 : data_dir_reg ? data_out_reg : GPIO_OUT;
  assign GPIO_INTR = INTR_MASK_REG & INTR_STATUS;
  // Register WRITE logic
  always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          data_dir_reg   <= '0;
          data_out_reg    <= '0;
          INTR_MASK_REG     <= '0;
          INTR_POLARITY_REG <= '0;
          INTR_STATUS  <= '0;
      	  INTR_TYPE_REG  <= '0;
      end else begin
          if (WRITE) begin
              case (ADDRESS)
                  32'h04: data_out_reg       <= WDATA;
                  32'h08: data_dir_reg       <= WDATA;
                  32'h10: INTR_MASK_REG      <= WDATA;
                  32'h14: INTR_STATUS        <= WDATA;
                  32'h18: INTR_TYPE_REG      <= WDATA;
      		  32'h1C: INTR_POLARITY_REG  <= WDATA;                    
              endcase
          end
      		else begin
              case (ADDRESS)
                  32'h00: RDATA <= data_in;       
                  32'h04: RDATA <= data_out_reg;
                  32'h08: RDATA <= data_dir_reg;     
                  32'h10: RDATA <= INTR_MASK_REG;     
                  32'h14: RDATA <= INTR_STATUS;  
                  32'h18: RDATA <= INTR_TYPE_REG;     
      		  32'h1C: RDATA <= INTR_POLARITY_REG;                
              endcase
          end
      end
  end
always @(posedge clk or negedge rst_n) begin
      prev_gpio <= GPIO_IN;
          for (int i = 0; i < DATA_WIDTH; i++) begin
            if (INTR_TYPE_REG[i] == 1'b1) begin
                  // Edge interrupt
              if (INTR_POLARITY_REG[i]) begin
                      INTR_STATUS[i] <= ~prev_gpio[i] & GPIO_IN[i];  // rising
                  end else begin
                      INTR_STATUS[i] <= prev_gpio[i] & ~GPIO_IN[i];  // falling
                  end
              end else begin
                  // Level interrupt
                if (INTR_POLARITY_REG[i]) begin
                      INTR_STATUS[i] <= GPIO_IN[i];   // high
                  end else begin
                      INTR_STATUS[i] <= ~GPIO_IN[i];  // low
                  end
              end
      	    end
end
endmodule

  
