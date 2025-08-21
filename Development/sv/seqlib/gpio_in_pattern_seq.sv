class gpio_in_pattern_seq extends gpio_base_seq;
  `uvm_object_utils(gpio_in_pattern_seq)

  // User-controlled pattern type (set via test)
  gpio_transaction::gpio_pattern_e pattern_sel;

  function new(string name = "gpio_in_pattern_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
    super.pre_body();
  endtask

  virtual task body();
    gtr = gpio_transaction::type_id::create("gtr");
    for(int i = 0; i < tcfg.no_of_in_tx; i++) begin
    // Create transaction
    $display("count of seq : %0d, i = %0d",tcfg.no_of_in_tx,i);

     // Start item first
      start_item(gtr);

    // Provide constraints before randomizing
      gtr.total_txn     = tcfg.no_of_in_tx;
      gtr.pattern_sel   = pattern_sel;
      gtr.pattern_index = i;

    $display("count of seq : %0d",tcfg.no_of_in_tx);
    // Randomize with constraint
      if(!gtr.randomize() with { pattern_sel == local::pattern_sel; }) begin
        `uvm_error("SEQ", $sformatf("Randomization failed at index %0d", i))
      end
    

    // Finish after randomization
      finish_item(gtr);
    end
  endtask

  virtual task post_body();
    super.post_body();
  endtask

endclass

