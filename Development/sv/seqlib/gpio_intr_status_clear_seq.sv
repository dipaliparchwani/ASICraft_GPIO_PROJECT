class gpio_intr_status_clear_seq extends gpio_intr_with_random_mask_seq;
  `uvm_object_utils(gpio_intr_status_clear_seq)

  function new(string name = "gpio_intr_status_clear_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;

    // First execute the base sequence logic (direction, intr_type, polarity, random mask)
    super.body();

    // Wait for 10 clocks (assuming clocking is managed by regmodel or you can use # delay)
    repeat (10) @(posedge grvif.clk);

    // Write all 1s to clear interrupt status
    regmodel.gpio_intr_status_reg_inst.write(status, 32'hFFFFFFFF);
    `uvm_info("GPIO_REG_SEQ", "INTR_STATUS register cleared by writing 0xFFFFFFFF", UVM_LOW);
  endtask

endclass

