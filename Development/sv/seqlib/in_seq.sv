class in_seq extends gpio_base_seq;
  `uvm_object_utils(in_seq)

  rand bit [`DATA_WIDTH-1:0] wdata;

  function new(string name = "in_seq");
    super.new(name);
  endfunction

  task pre_body();
    super.pre_body();
  endtask

  task body();
    gtr = gpio_transaction::type_id::create("gtr");
    repeat(tcfg.no_of_in_tx) begin
      assert(this.randomize());
      // Create and send transaction
      start_item(gtr);
      gtr.gpio_in = wdata;
      finish_item(gtr);
    end

  endtask

  task post_body();
    super.post_body();
  endtask

endclass

