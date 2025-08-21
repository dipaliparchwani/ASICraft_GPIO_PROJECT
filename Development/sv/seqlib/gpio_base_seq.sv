class gpio_base_seq extends uvm_sequence;
  `uvm_object_utils(gpio_base_seq)
  virtual gpio_if gvif;
  gpio_transaction gtr;
  gpio_reg_block regmodel;
  gpio_test_cfg tcfg;
  uvm_status_e status;

  function new(string name = "gpio_base_seq");
    super.new(name);
    if(!uvm_config_db#(gpio_test_cfg)::get(null,"*","tcfg",tcfg))
      `uvm_error(get_full_name(), "Error getting object Handle")
  endfunction

  task pre_body();
    if(!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif))
      `uvm_error("GPIO_SEQ", "Error getting Interface Handle")

    $display("seq count = %0d",tcfg.no_of_in_tx);
  endtask

  task post_body();
    @(posedge gvif.clk);
  endtask

endclass

