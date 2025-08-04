class out_reg_seq extends uvm_reg_sequence;
  `uvm_object_utils(out_reg_seq)
  gpio_reg_block regmodel;
  virtual gpio_reg_if grvif;

  function new(string name = "out_reg_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;
    bit [`DATA_WIDTH-1:0] mdata;
    if(!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif))
      `uvm_error("GPIO_REG_DRV", "Error getting Interface Handle")
    regmodel.gpio_dir_reg_inst.write(status,32'hffffffff);
    mdata = regmodel.gpio_dir_reg_inst.get_mirrored_value();
    `uvm_info("REG_SEQ", $sformatf("DIR Register mirrored value : %0h",mdata),UVM_NONE);
    regmodel.gpio_data_out_reg_inst.write(status,32'h11111111);
    mdata = regmodel.gpio_data_out_reg_inst.get_mirrored_value();
    `uvm_info("REG_SEQ", $sformatf("write tx to dut data_out reg : %0h",mdata),UVM_NONE);
    repeat(2)
      @(posedge grvif.clk);
  endtask

endclass
