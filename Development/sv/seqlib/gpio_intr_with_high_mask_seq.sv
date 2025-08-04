class gpio_intr_with_high_mask_seq extends gpio_intr_config_base_seq;
  `uvm_object_utils(gpio_intr_with_high_mask_seq)

  function new(string name = "gpio_intr_with_high_mask_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;
    bit [`DATA_WIDTH-1:0] mdata;

    // First execute base sequence logic: input direction + randomized type/polarity
    super.body();

    // Now set intr_mask to all 1s (enable all interrupts)
    regmodel.gpio_intr_mask_reg_inst.write(status, 32'hFFFFFFFF);
    mdata = regmodel.gpio_intr_mask_reg_inst.get_mirrored_value();
    `uvm_info("GPIO_REG_SEQ", $sformatf("INTR_MASK register written: 0x%08h", mdata), UVM_LOW);
  endtask

endclass

