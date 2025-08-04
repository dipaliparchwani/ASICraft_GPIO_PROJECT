class gpio_in_random_seq extends gpio_in_toggle_base_seq;
  `uvm_object_utils(gpio_in_random_seq)

  function new(string name = "gpio_in_random_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tr;
    // Try randomizing number of transactions
    if(!randomize()) begin
      `uvm_warning(get_type_name(), "Randomization of no_of_txn failed, using default = 4")
      no_of_txn = 4;
    end


    for (int i = 0; i < no_of_txn; i++) begin
      tr = gpio_transaction::type_id::create($sformatf("tr_%0d", i));
      start_item(tr);
        // Fully random gpio_in across all bits
      assert(tr.randomize() with { gpio_in inside {[0:(2**`DATA_WIDTH)-1]};})
      else 
        `uvm_error(get_type_name(), "Randomization of gpio_in failed.")
      finish_item(tr);
    end
    @(posedge gvif.clk);
  endtask
endclass

