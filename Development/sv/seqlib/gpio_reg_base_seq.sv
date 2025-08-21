class gpio_reg_base_seq extends uvm_sequence;
  `uvm_object_utils(gpio_reg_base_seq)
  virtual gpio_reg_if grvif;
  gpio_reg_block regmodel;
  gpio_test_cfg tcfg;

  function new(string name = "gpio_reg_base_seq");
    super.new(name);
    if(!uvm_config_db#(gpio_test_cfg)::get(null,"*","tcfg",tcfg))
      `uvm_error(get_full_name(), "Error getting object Handle")
  endfunction

  task pre_body();
    if(!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif))
      `uvm_error("GPIO_SEQ", "Error getting Interface Handle")
  endtask

  task post_body();
    repeat(2)
      @(posedge grvif.clk);
  endtask

endclass
