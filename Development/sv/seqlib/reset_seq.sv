class reset_seq extends uvm_sequence;
  `uvm_object_utils(reset_seq)
  virtual gpio_if gvif;
  gpio_transaction str;

  function new(string name = "in_seq");
    super.new(name);
  endfunction


  task body();
    if(!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif))
      `uvm_error("GPIO_SEQ", "Error getting Interface Handle")
    str = gpio_transaction::type_id::create("str");
    start_item(str);
    gvif.rst_n = 1; 
    #5 gvif.rst_n = 0;
    #10 gvif.rst_n = 1;
    finish_item(str);
  endtask

endclass
