class gpio_driver extends uvm_driver #(gpio_transaction);
  `uvm_component_utils(gpio_driver)

  virtual gpio_if gvif;

  function new(string name = "gpio_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif))
      `uvm_error("GPIO_DRV", "Error getting Interface Handle")
  endfunction 

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      gpio_transaction dtr;
      @(posedge gvif.clk or negedge gvif.rst_n);
      if(!gvif.rst_n) begin
        gvif.gpio_in <= 32'h00000000;
      end
      else begin
        seq_item_port.get_next_item(dtr);
        gvif.gpio_in <= dtr.gpio_in;
        seq_item_port.item_done();
      end
      `uvm_info(get_full_name(),$sformatf("gpio_in value driven on interface : %0h",gvif.gpio_in),UVM_NONE);
    end
  endtask
  
endclass
