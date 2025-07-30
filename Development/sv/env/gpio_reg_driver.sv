class gpio_reg_driver extends uvm_driver #(gpio_reg_transaction);
  `uvm_component_utils(gpio_reg_driver);
   
  virtual gpio_reg_if grvif;
  function new(string name = "gpio_reg_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif))
      `uvm_error("GPIO_REG_DRV", "Error getting Interface Handle")
  endfunction 

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      gpio_reg_transaction dtr ;

      @(posedge grvif.clk or negedge grvif.rst_n);
        if(!grvif.rst_n) begin
	  grvif.WRITE <= 0;
	  grvif.WDATA <= 32'h00000000;
	  grvif.ADDRESS <= 32'hzzzzzzzz ;
	end
        else begin
	  seq_item_port.get_next_item(dtr);
          grvif.WRITE <= dtr.WRITE;
	  grvif.ADDRESS <= dtr.ADDRESS;
	  grvif.WDATA <= dtr.WDATA;
	  seq_item_port.item_done();
        end
	`uvm_info(get_full_name(),$sformatf("[%0t] : value of WDATA : %0h, WRITE : %0h, ADDRESS : %0h",$time,grvif.WDATA,grvif.WRITE,grvif.ADDRESS),UVM_NONE)

    end
  endtask

endclass
