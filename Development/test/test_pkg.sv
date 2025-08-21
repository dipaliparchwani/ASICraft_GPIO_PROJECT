package test_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ral_pkg::*;
  import seq_pkg::*;
  import env_pkg::*;
  `include "gpio_test.sv"
  `include "gpio_in_out_functionality_test.sv"
  `include "gpio_error_test.sv"
  `include "gpio_in_pattern_test.sv"
  `include "gpio_dir_random_test.sv"
  `include "gpio_intr_random_test.sv"
  `include "gpio_reset_test.sv"
  `include "gpio_reg_bit_bash_test.sv"
  `include "gpio_reg_access_test.sv"
endpackage
