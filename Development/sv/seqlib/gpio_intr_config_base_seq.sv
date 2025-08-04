class gpio_intr_config_base_seq extends uvm_reg_sequence;
  `uvm_object_utils(gpio_intr_config_base_seq)

  gpio_reg_block regmodel;
  virtual gpio_reg_if grvif;

  // Random variables for intr_type and intr_polarity
  rand bit [`DATA_WIDTH-1:0] rand_intr_type;
  rand bit [`DATA_WIDTH-1:0] rand_intr_polarity;

  function new(string name = "gpio_intr_config_base_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;
    bit [`DATA_WIDTH-1:0] mdata;

    // Get virtual interface from config DB
    if (!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif)) begin
      `uvm_error("GPIO_REG_SEQ", "Unable to get grvif from config DB")
    end

    // Set GPIO direction as INPUT (0)
    regmodel.gpio_dir_reg_inst.write(status, 32'h00000000);
    mdata = regmodel.gpio_dir_reg_inst.get_mirrored_value();
    `uvm_info("GPIO_REG_SEQ", $sformatf("DIR register set as input: 0x%08h", mdata), UVM_LOW);

    // Randomize and write intr_type and intr_polarity
    if (!randomize()) begin
      `uvm_error("GPIO_REG_SEQ", "Randomization failed")
    end

    regmodel.gpio_intr_type_reg_inst.write(status, rand_intr_type);
    `uvm_info("GPIO_REG_SEQ", $sformatf("INTR_TYPE register written: 0x%08h", rand_intr_type), UVM_LOW);

    regmodel.gpio_intr_polarity_reg_inst.write(status, rand_intr_polarity);
    `uvm_info("GPIO_REG_SEQ", $sformatf("INTR_POLARITY register written: 0x%08h", rand_intr_polarity), UVM_LOW);
  endtask

endclass

