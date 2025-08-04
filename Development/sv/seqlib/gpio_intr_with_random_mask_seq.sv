class gpio_intr_with_random_mask_seq extends gpio_intr_config_base_seq;
  `uvm_object_utils(gpio_intr_with_random_mask_seq)

  rand bit [`DATA_WIDTH-1:0] rand_mask;  // Random interrupt mask value

  function new(string name = "gpio_intr_with_random_mask_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;
    bit [`DATA_WIDTH-1:0] mdata;

    // First execute base sequence logic (direction + randomized intr type and polarity)
    super.body();

    // Randomize the mask
    if (!randomize(rand_mask)) begin
      `uvm_error("GPIO_SEQ", "Failed to randomize rand_mask")
      return;
    end

    // Apply the randomized interrupt mask to the DUT
    regmodel.gpio_intr_mask_reg_inst.write(status, rand_mask);
    mdata = regmodel.gpio_intr_mask_reg_inst.get_mirrored_value();
    `uvm_info("GPIO_REG_SEQ", $sformatf("Random INTR_MASK value written: 0x%08h", mdata), UVM_LOW);
  endtask

endclass

