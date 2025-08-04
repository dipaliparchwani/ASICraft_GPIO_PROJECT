`include "uvm_macros.svh"
`include "../sv/env/defines.sv"
import uvm_pkg::*;
import gpio_pkg::*;

module tb;
  logic clk = 0;
  logic rst_n;
  string freq_str;
  real freq;
  real clk_period;
  //gpio interface handle
  gpio_if gif(.clk(clk),.rst_n(rst_n));
  //gpio register interface handle
  gpio_reg_if grif (.clk(clk),.rst_n(rst_n));

  clk_period_checker chk(.clk(clk),.clk_period(clk_period));

  GPIO dut (.clk(clk),.rst_n(rst_n),.WRITE(grif.WRITE),.ADDRESS(grif.ADDRESS),.WDATA(grif.WDATA),.RDATA(grif.RDATA),.GPIO_IN(gif.gpio_in),.GPIO_OUT(gif.gpio_out),.GPIO_INTR(gif.gpio_intr));

  genvar i;
  generate
    for (i = 0; i < `DATA_WIDTH; i++) begin : gen_my_module
      gpio_assertion gpio_assertion_inst (
        .clk           (tb.clk),
        .rst_n         (tb.rst_n),
        .gpio_in       (tb.dut.GPIO_IN[i]),
        .gpio_intr     (tb.dut.GPIO_INTR[i]),
        .intr_status   (tb.dut.INTR_STATUS[i]),
        .intr_type     (tb.dut.INTR_TYPE[i]),
        .intr_polarity (tb.dut.INTR_POLARITY[i]),
        .intr_mask     (tb.dut.INTR_MASK[i])
      );
    end
  endgenerate

  initial begin
    gif.print();
    grif.print();
    run_test("gpio_test");
  end
  initial begin
    if($value$plusargs("freq=%s", freq_str)) begin
      string unit;
      real freq_val;
      if($sscanf(freq_str, "%f%s", freq_val, unit)) begin

      // Normalize to Hz
        if(unit == "Hz" || unit == "hz")
          freq = freq_val;
        else if(unit == "KHz" || unit == "khz")
          freq = freq_val * 1e3;
        else if (unit == "MHz" || unit == "mhz")
          freq = freq_val * 1e6;
        else if (unit == "GHz" || unit == "ghz")
          freq = freq_val * 1e9;
        else begin
          `uvm_fatal("TB_TOP", $sformatf("Invalid frequency unit or format: '%s'.\nUse format like +freq=50MHz with valid units: Hz/kHz/MHz/GHz.",freq_str))
	end
      end
    end
    //if frequency is not provided from argument
    else begin
      // Default frequency is 50MHz
      freq = 50e6; // in HZ
    end
	
    clk_period = ((1/(freq)) * 1e9);

    $info("freq = %0.2f Hz, clk_period = %0.2f ns", freq, clk_period);
  end



  // Clock generation
  initial begin
    if(clk_period < 0)
      `uvm_error("TB_TOP","INVALID FREQUENCY IS PROVIDED (PLEASE PROVIDE VALID FREQUENCY)")
    forever #(clk_period / 2) clk = ~clk;  //clk designed based on  Frequency
  end

  /*initial begin
    rst_n = 1;
    #5 rst_n = 0;
    #10 rst_n = 1;
  end*/

  initial begin
    $dumpfile("gpio.vcd");
    $dumpvars(0,tb);
  end
 
endmodule
