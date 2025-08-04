class gpio_in_read_repeat_seq extends uvm_reg_sequence;
  `uvm_object_utils(gpio_in_read_repeat_seq)

  rand int no_of_txn;
  gpio_reg_block regmodel;
  virtual gpio_reg_if grvif;

  constraint tx_range_c {
    no_of_txn inside {[1:100]}; // Randomize number of reads
  }

  function new(string name = "gpio_in_read_repeat_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;
    bit [`DATA_WIDTH-1:0] dir_val, rdata;
    if(!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif))
      `uvm_error("GPIO_REG_DRV", "Error getting Interface Handle")

    // Randomize number of transactions
    if (!randomize()) begin
      `uvm_warning(get_type_name(), "Randomization of no_of_txn failed, using default = 4")
      no_of_txn = 4;
    end

    // Set direction to input mode
    dir_val = '0;
    regmodel.gpio_dir_reg_inst.write(status, dir_val);
    `uvm_info(get_type_name(), $sformatf("Configured gpio_dir = %0h (input mode)", dir_val), UVM_MEDIUM)

    // Repeat read operation
    repeat (no_of_txn) begin
      regmodel.gpio_data_in_reg_inst.read(status, rdata);
      `uvm_info(get_type_name(), $sformatf("Read gpio_data_in_reg: 0x%0h", rdata), UVM_MEDIUM)
    end

    // Delay after all reads (2 clock cycles)
    @(posedge grvif.clk);
    @(posedge grvif.clk);
  endtask

endclass

