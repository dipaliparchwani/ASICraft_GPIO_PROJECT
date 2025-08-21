
class gpio_reg_reset_check_seq extends in_out_reg_seq;
  `uvm_object_utils(gpio_reg_reset_check_seq)

  rand int reset_cycles;
  bit [`DATA_WIDTH-1:0] rdata_dir, rdata_out, rdata_oe, rdata_in,
                        rdata_mask, rdata_status, rdata_type, rdata_polarity;

  function new(string name = "gpio_reg_reset_check_seq");
    super.new(name);
  endfunction

  constraint c_reset_cycles { reset_cycles inside {[5:10]}; }

  task body();
    uvm_status_e status;

    // Call base sequence body to get grvif and regmodel
    super.body();

    // Apply reset using force/release for random cycles
    /*force grvif.rst_n = 0;
    repeat (reset_cycles) @(posedge grvif.clk);
    release grvif.rst_n;*/
    @(posedge grvif.clk);

    // Read each register explicitly to capture post-reset values
    regmodel.gpio_dir_reg_inst.read(status, rdata_dir);
    regmodel.gpio_data_in_reg_inst.read(status, rdata_in);
    regmodel.gpio_data_out_reg_inst.read(status, rdata_out);
    regmodel.gpio_oe_reg_inst.read(status, rdata_oe);
    regmodel.gpio_intr_mask_reg_inst.read(status, rdata_mask);
    regmodel.gpio_intr_status_reg_inst.read(status, rdata_status);
    regmodel.gpio_intr_type_reg_inst.read(status, rdata_type);
    regmodel.gpio_intr_polarity_reg_inst.read(status, rdata_polarity);

    // Report mismatch if any register didn't reset to zero
    if ((rdata_dir | rdata_out | rdata_oe | rdata_mask | rdata_status | rdata_in | rdata_type | rdata_polarity) !== 0) begin
      `uvm_error("RESET_CHECK", $sformatf("Reset mismatch! dir=%0h, out=%0h, oe=%0h, mask=%0h, status=%0h, type=%0h, polarity=%0h, in=%0h",rdata_dir, rdata_out, rdata_oe, rdata_mask, rdata_status,rdata_type, rdata_polarity, rdata_in))
    end
    else begin
      `uvm_info("RESET_CHECK", "All registers correctly reset to 0", UVM_LOW)
    end
    @(posedge grvif.clk);
  endtask

endclass

