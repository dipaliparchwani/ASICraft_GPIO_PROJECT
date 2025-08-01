checker clk_period_checker (input logic clk, input time clk_period);

  time t1, t2;
  real measured_clk_period;

  initial begin
    wait (clk_period > 0); // Ensure expected value is set

    // Wait for first rising edge
    @(posedge clk);
    t1 = $time;

    // Wait for second rising edge
    @(posedge clk);
    t2 = $time;

    measured_clk_period = t2 - t1;

    `uvm_info("CLK_CHECKER", $sformatf("Measured clk_period = %0.2f ns, Expected = %0.2f ns", measured_clk_period, clk_period), UVM_NONE)

    if (measured_clk_period != clk_period)
      `uvm_fatal("CLK_CHECK", $sformatf("Clock period mismatch!\nExpected: %0.2f ns\nMeasured: %0.2f ns", clk_period, measured_clk_period))
    else
      `uvm_info("CLK_CHECK", $sformatf("Clock period verified: %0.2f ns", measured_clk_period), UVM_LOW)
  end

endchecker

