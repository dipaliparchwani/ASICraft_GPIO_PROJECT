class gpio_reg_reset_check_seq extends in_out_reg_seq;
  `uvm_object_utils(gpio_reg_reset_check_seq)

  rand int reset_cycles;
  bit [`DATA_WIDTH-1:0] mdata_dir, mdata_out, mdata_oe,mdata_in,
                        mdata_mask, mdata_status, mdata_type, mdata_polarity;

  function new(string name = "gpio_reg_reset_check_seq");
    super.new(name);
  endfunction

  constraint c_reset_cycles { reset_cycles inside {[5:10]}; }

  task body();

    // Call base sequence body to get grvif and regmodel
    super.body();

    // Apply reset using force/release for random cycles
    grvif.rst_n = 0;
    repeat (reset_cycles) @(posedge grvif.clk);
    grvif.rst_n = 1;


    // Collect mirrored reset values
    mdata_dir      = regmodel.gpio_dir_reg_inst.get_mirrored_value();
    mdata_in       = regmodel.gpio_data_in_reg_inst.get_mirrored_value();
    mdata_out      = regmodel.gpio_data_out_reg_inst.get_mirrored_value();
    mdata_oe       = regmodel.gpio_oe_reg_inst.get_mirrored_value();
    mdata_mask     = regmodel.gpio_intr_mask_reg_inst.get_mirrored_value();
    mdata_status   = regmodel.gpio_intr_status_reg_inst.get_mirrored_value();
    mdata_type     = regmodel.gpio_intr_type_reg_inst.get_mirrored_value();
    mdata_polarity = regmodel.gpio_intr_polarity_reg_inst.get_mirrored_value();

    // Report mismatch if any register didn't reset to zero
    if ((mdata_dir | mdata_out | mdata_oe | mdata_mask | mdata_status | mdata_in | mdata_type | mdata_polarity) !== 0) begin
      `uvm_error("RESET_CHECK", $sformatf(
        "Reset mismatch! dir=%0h, out=%0h, oe=%0h, mask=%0h, status=%0h, type=%0h, polarity=%0h, in=%0h",
        mdata_dir, mdata_out, mdata_oe, mdata_mask, mdata_status, mdata_type, mdata_polarity,mdata_in))
    end else begin
      `uvm_info("RESET_CHECK", "All registers correctly reset to 0", UVM_LOW)
    end

    @(posedge grvif.clk);

  endtask

endclass

