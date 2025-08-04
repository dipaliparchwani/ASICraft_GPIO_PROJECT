class in_seq extends uvm_sequence;
  `uvm_object_utils(in_seq)
  gpio_transaction str;
  virtual gpio_if gvif;

  function new(string name = "in_seq");
    super.new(name);
  endfunction


  task body();
    if(!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif))
      `uvm_error("GPIO_SEQ", "Error getting Interface Handle")
    str = gpio_transaction::type_id::create("str");
    start_item(str);
    repeat(2)
      @(posedge gvif.clk);
    str.gpio_in = 32'hffffffff;
    finish_item(str);
  endtask

endclass
