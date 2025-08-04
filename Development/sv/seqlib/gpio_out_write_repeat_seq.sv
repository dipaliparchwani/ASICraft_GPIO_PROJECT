class gpio_out_write_repeat_seq extends uvm_reg_sequence;
  `uvm_object_utils(gpio_out_write_repeat_seq)

  rand int no_of_txn;
  rand bit [`DATA_WIDTH-1:0] wdata;
  virtual gpio_reg_if grvif;

  gpio_reg_block regmodel;

  constraint tx_range_c {
    no_of_txn inside {[1:100]}; // Randomize number of writes
  }

  function new(string name = "gpio_out_write_repeat_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;
    bit [`DATA_WIDTH-1:0] dir_val;
    if(!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif))
      `uvm_error("GPIO_REG_DRV", "Error getting Interface Handle")

    // Randomize number of transactions
    if (!randomize()) begin
      `uvm_warning(get_type_name(), "Randomization of no_of_txn failed, using default = 4")
      no_of_txn = 4;
    end

    // Set direction to output mode (all bits '1)
    dir_val = '1;
    regmodel.gpio_dir_reg_inst.write(status, dir_val);
    `uvm_info(get_type_name(), $sformatf("Configured gpio_dir = %0h (output mode)", dir_val), UVM_MEDIUM)

    // Repeat write operation
    repeat (no_of_txn) begin
      if (!randomize(wdata)) begin
        `uvm_warning(get_type_name(), "Randomization of wdata failed, using default value")
        wdata = $urandom;
      end
      regmodel.gpio_data_out_reg_inst.write(status, wdata);
      `uvm_info(get_type_name(), $sformatf("Wrote 0x%0h to gpio_data_out_reg", wdata), UVM_MEDIUM)
    end

    // Delay after all writes (2 clock cycles)
    @(posedge grvif.clk);
    @(posedge grvif.clk);
  endtask

endclass

