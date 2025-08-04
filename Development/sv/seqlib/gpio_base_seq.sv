class gpio_base_seq extends uvm_sequence;
  `uvm_object_utils(gpio_base_seq)
  gpio_transaction str;

  function new(string name = "gpio_base_seq");
    super.new(name);
  endfunction


  task body();
    str = gpio_transaction::type_id::create("str");
    start_item(str);
    finish_item(str);
  endtask

endclass

