module gpio_assertion (
  input logic        clk,
  input logic        rst_n,
  input logic        gpio_in,
  input logic        gpio_intr,
  input logic        intr_status,
  input logic        intr_type,
  input logic        intr_polarity,
  input logic        intr_mask
);
  // ==========================================================================
  // Sequences: Define condition for each interrupt type trigger
  // ==========================================================================

  // Level Low Interrupt Condition
  sequence seq_level_low;
    (!intr_type && !intr_polarity  && !gpio_in);
  endsequence

  // Level High Interrupt Condition
  sequence seq_level_high;
    (!intr_type && intr_polarity  && gpio_in);
  endsequence

  // Falling Edge Interrupt Condition
  sequence seq_falling_edge;
    (intr_type && !intr_polarity && $fell(gpio_in));
  endsequence

  // Rising Edge Interrupt Condition
  sequence seq_rising_edge;
    (intr_type && intr_polarity  && $rose(gpio_in));
  endsequence

  // Output Response: When interrupt condition is met
  sequence seq_intr_response;
    (intr_mask && intr_status);
  endsequence

  sequence seq_intr_no_response;
    (((!intr_mask) && (intr_status)) || ((!intr_mask) && (!intr_status)) || ((intr_mask) && (!intr_status)));
  endsequence
  // ==========================================================================
  // Properties: Assert that if a condition triggers, response should follow
  // ==========================================================================

  // Level Low Interrupt
  property low_level_intr;
    disable iff(!rst_n) @(posedge clk)
      seq_level_low |=> intr_status;
  endproperty
  a_low_level_intr: assert property(low_level_intr)
    else `uvm_error("LOW_INTR","Low level interrupt failed");

  // Level High Interrupt
  property high_level_intr;
    disable iff(!rst_n) @(posedge clk)
      seq_level_high |=> intr_status;
  endproperty
  a_high_level_intr: assert property(high_level_intr)
    else `uvm_error("HIGH_INTR", "High level interrupt failed");

  // Falling Edge Interrupt
  property falling_edge_intr;
    disable iff(!rst_n) @(posedge clk)
      seq_falling_edge |=> intr_status;
  endproperty
  a_falling_edge_intr: assert property(falling_edge_intr)
    else `uvm_error("FALL_EDGE_INTR","Falling edge interrupt failed");

  // Rising Edge Interrupt
  property rising_edge_intr;
    disable iff(!rst_n) @(posedge clk)
      seq_rising_edge |=> intr_status;
  endproperty
  a_rising_edge_intr: assert property(rising_edge_intr)
    else `uvm_error("RISE_EDGE_INTR","Rising edge interrupt failed ");

  // Always Match: gpio_intr must always equal intr_status
  property gpio_intr_response;
    disable iff(!rst_n) @(posedge clk)
      seq_intr_response |-> gpio_intr;
  endproperty
  a_gpio_intr_response: assert property(gpio_intr_response)
    else `uvm_error("gpio_intr_response","INTR_STATUS_MISMATCH");

  property gpio_intr_no_response;
    disable iff(!rst_n) @(posedge clk)
      seq_intr_no_response |-> !gpio_intr;
  endproperty
  a_gpio_intr_no_response: assert property(gpio_intr_no_response)
    else `uvm_error("gpio_intr_no_response","INTR_STATUS_MISMATCH");
endmodule

