class gpio_intr_config_base_seq extends gpio_reg_base_seq;
  `uvm_object_utils(gpio_intr_config_base_seq)

  // Random variables for intr_type and intr_polarity
//  rand bit [`DATA_WIDTH-1:0] rand_intr_type;
 // rand bit [`DATA_WIDTH-1:0] rand_intr_polarity;

  function new(string name = "gpio_intr_config_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    super.pre_body();
  endtask

  task body();
    uvm_status_e status;
    //bit [`DATA_WIDTH-1:0] mdata;

    regmodel.gpio_intr_type_reg_inst.write(status,32'hffffffff);
    //`uvm_info("GPIO_REG_SEQ", $sformatf("INTR_TYPE register written: 0x%08h", rand_intr_type), UVM_LOW);

    regmodel.gpio_intr_polarity_reg_inst.write(status,32'hffffffff);
   // `uvm_info("GPIO_REG_SEQ", $sformatf("INTR_POLARITY register written: 0x%08h", rand_intr_polarity), UVM_LOW);
    regmodel.gpio_intr_mask_reg_inst.write(status,32'hffffffff);
  endtask

  task post_body();
    super.post_body();
  endtask

endclass

