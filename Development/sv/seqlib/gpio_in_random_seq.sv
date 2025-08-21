class gpio_in_random_seq extends gpio_base_seq;
  `uvm_object_utils(gpio_in_random_seq)

  function new(string name = "gpio_in_random_seq");
    super.new(name);
  endfunction

  task pre_body();
    super.pre_body();
  endtask

  task body();
    // Try randomizing number of transactions
    if(!randomize()) begin
      `uvm_warning(get_type_name(), "Randomization of no_of_txn failed, using default = 4")
    end


    for(int i = 0; i < tcfg.no_of_in_tx; i++) begin
      gtr = gpio_transaction::type_id::create($sformatf("gtr_%0d", i));
      start_item(gtr);
        // Fully random gpio_in across all bits
      assert(gtr.randomize() with {gpio_in inside {[0:(2**`DATA_WIDTH)-1]};})
      else 
        `uvm_error(get_type_name(), "Randomization of gpio_in failed.")
      finish_item(gtr);
    end
  endtask

    task post_body();
      super.post_body();
    endtask


endclass

