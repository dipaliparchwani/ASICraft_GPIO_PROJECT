class in_seq extends uvm_sequence;
  `uvm_object_utils(in_seq)
  gpio_transaction str;

  function new(string name = "in_seq");
    super.new(name);
  endfunction


  task body();
    str = gpio_transaction::type_id::create("str");
    start_item(str);
    str.gpio_in = 32'hFFFFFFFF;
    finish_item(str);
  endtask

endclass
