package ral_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  `include "gpio_data_in_reg.sv"
  `include "gpio_data_out_reg.sv"
  `include "gpio_oe_reg.sv"
  `include "gpio_intr_mask_reg.sv"
  `include "gpio_intr_status_reg.sv"
  `include "gpio_intr_type_reg.sv"
  `include "gpio_intr_polarity_reg.sv"
  `include "gpio_dir_reg.sv"
  `include "gpio_reg_block.sv"
  `include "../seqlib/gpio_reg_transaction.sv"
  `include "gpio_adapter.sv"
endpackage

