/*******************************************************************************************************************/
/*                                                                                                                 */
/*  PROJECT NAME : GPIO VIP                                                                                        */
/*  MODULE NAME  : gpio_assertion.sv                                                                               */
/*  DESCRIPTION  :This module contains SystemVerilog assertions to verify the correctness of interrupt generation  */
/*                                                                                                                 */
/*******************************************************************************************************************/
module gpio_assertion(
  input logic clk,
  input logic rst_n,
  input logic gpio_in,
  input logic gpio_out,
  input logic data_out,
  input logic data_in,
  input logic gpio_dir,
  input logic gpio_intr,
  input logic intr_status,
  input logic intr_type,
  input logic intr_polarity,
  input logic intr_mask,
  input int index
);
  // ==========================================================================
  // Sequences: Define condition for each interrupt type trigger
  // ==========================================================================

  // Level Low Interrupt Condition
  sequence seq_level_low;
    ((!intr_type) && (!intr_polarity) && (!gpio_in));
  endsequence

  // Level High Interrupt Condition
  sequence seq_level_high;
    ((!intr_type) && (intr_polarity) && (gpio_in));
  endsequence

  // Falling Edge Interrupt Condition
  sequence seq_falling_edge;
    ((intr_type) && (!intr_polarity) && $fell(gpio_in));
  endsequence

  // Rising Edge Interrupt Condition
  sequence seq_rising_edge;
    (intr_type && intr_polarity && $rose(gpio_in));
  endsequence

  // Interrupt should be set when mask is enabled and status is high
  sequence seq_intr_response;
    (intr_mask && intr_status);
  endsequence
  // No Interrupt generate for this condition 
  sequence seq_intr_no_response;
    (((!intr_mask) && (intr_status)) || ((!intr_mask) && (!intr_status)) || ((intr_mask) && (!intr_status)));
  endsequence
  // ==========================================================================
  // Properties: Assert that if a condition triggers
  // ==========================================================================

  // Level Low Interrupt
  property low_level_intr;
    @(posedge clk)
    disable iff(!rst_n) 
      seq_level_low |=> intr_status;
  endproperty
  a_low_level_intr: assert property(low_level_intr)
    else `uvm_error("LOW_INTR",$sformatf("Low level interrupt failed at index : %0d",index));

  // Level High Interrupt
  property high_level_intr;
    @(posedge clk)
    disable iff(!rst_n)
      seq_level_high |=> intr_status;
  endproperty
  a_high_level_intr: assert property(high_level_intr)
    else `uvm_error("HIGH_INTR", $sformatf("High level interrupt failed at index : %0d",index));

  // Falling Edge Interrupt
  property falling_edge_intr;
    @(posedge clk)
    disable iff(!rst_n) 
      seq_falling_edge |=> intr_status;
  endproperty
  a_falling_edge_intr: assert property(falling_edge_intr)
    else `uvm_error("FALL_EDGE_INTR","Falling edge interrupt failed");

  // Rising Edge Interrupt
  property rising_edge_intr;
    @(posedge clk)
    disable iff(!rst_n)
      seq_rising_edge |=> intr_status;
  endproperty
  a_rising_edge_intr: assert property(rising_edge_intr)
    else `uvm_error("RISE_EDGE_INTR",$sformatf("Rising edge interrupt failed at index : %0d",index));

  // gpio_intr is high when intr_status is set and interrupt is masked (enabled)
  property gpio_intr_response;
    @(posedge clk)
    disable iff(!rst_n)
      seq_intr_response |-> gpio_intr;
  endproperty
  a_gpio_intr_response: assert property(gpio_intr_response)
    else `uvm_error("gpio_intr_response","INTR_STATUS_MISMATCH");

 // Assert that gpio_intr remains low when interrupt is not expected
  property gpio_intr_no_response;
    @(posedge clk)
    disable iff(!rst_n)
      seq_intr_no_response |-> (!gpio_intr);
  endproperty
  a_gpio_intr_no_response: assert property(gpio_intr_no_response)
    else `uvm_error("gpio_intr_no_response","INTR_STATUS_MISMATCH");
//----------------------------------------------------------------------------------------------------
  // check that gpio_out does not change when direction is input

  property p_gpio_out_stable_in_input;
    @(posedge clk)
    disable iff(!rst_n)
    (!gpio_dir) && $past(rst_n) |-> $stable(gpio_out);
  endproperty

  a_dir_in_check: assert property(p_gpio_out_stable_in_input)
    else `uvm_error("DIR_IN", $sformatf("gpio_out changed even though direction is input : %0d",index));
//------------------------------------------------------------------------------------------------------  
//
//----------------------------------------------------------------------------------------------------
  // check that data_in does not change when direction is output

  property p_data_in_stable_in_output;
    @(posedge clk)
    disable iff(!rst_n)
    (gpio_dir) |-> $stable(data_in);
  endproperty

  a_dir_out_check: assert property(p_data_in_stable_in_output)
    else `uvm_error("DIR_OUT", $sformatf("data_in changed even though direction is output at index : %0d",index));
//------------------------------------------------------------------------------------------------------  
  // Reset Condition Assertion
  property rst_check;
    (!rst_n) |-> ((!gpio_out) && (!gpio_intr));
  endproperty

  a_rst_check:assert property (@(rst_n) rst_check)
    else `uvm_error("RESET_ASSERTION",$sformatf("gpio_out or gpio_intr is not zero during reset at index : %0d",index));
 

endmodule

