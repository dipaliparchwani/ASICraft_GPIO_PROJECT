package seq_pkg; 
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ral_pkg::*;
  `include "../../test/gpio_test_cfg.sv"
  //`include "../../test/gpio_test.sv"
  `include "gpio_transaction.sv"
  `include "gpio_base_seq.sv"
  `include "gpio_reg_base_seq.sv"
  `include "dir_in_seq.sv"
  `include "in_seq.sv"
  `include "dir_out_seq.sv"
  `include "out_drive_seq.sv"
  `include "gpio_in_pattern_seq.sv"
  `include "gpio_intr_config_base_seq.sv"
  `include "dir_random_seq.sv"
  `include "intr_random_seq.sv"
  `include "intr_clear_seq.sv"
  //`include "uvm_reg_hw_reset_seq.sv"
endpackage

