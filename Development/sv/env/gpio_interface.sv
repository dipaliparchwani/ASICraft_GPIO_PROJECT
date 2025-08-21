//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : gpio_interface.sv                                                  #
//----COMPONENT    : GPIO INTERFACE                                                     #  
//----DESCRIPTION  : This interface defines the GPIO signals: input, output,            #
//----               and interrupt lines. It is reusable and simplifies connection to   #
//----               both the DUT and UVM testbench components.                         #
//#######################################################################################

interface gpio_if (input logic clk, rst_n);
  
  //============================================
  // GPIO Block Signals
  //============================================
  logic [`DATA_WIDTH-1:0] gpio_in;    // Driven by Testbench - represents external inputs
  logic [`DATA_WIDTH-1:0] gpio_out;   // Driven by DUT - represents output pins
  logic [`DATA_WIDTH-1:0] gpio_intr;  // Driven by DUT - interrupt status per pin

  //============================================
  // Interface Name for UVM config_db
  //============================================
  string inst_name = $sformatf("%m"); // Get hierarchical name of interface instance


  // Register interface in UVM config DB
  initial begin
    virtual gpio_if gvif;
    gvif = interface::self();
    uvm_config_db#(virtual gpio_if)::set(null, inst_name, "gvif", gvif);
  end


  /*
  // Clocking block for GPIO driver
  clocking gpio_cb @(posedge clk);
    default input #0 output #0;
    output gpio_in;
    input  gpio_out, gpio_intr;
  endclocking: gpio_cb

  // Clocking block for GPIO monitor
  clocking gmonitor_cb @(posedge clk);
    default input #0;
    input  gpio_in, gpio_out, gpio_intr;
  endclocking: gmonitor_cb

  // Modport for GPIO driver
  modport gpio (
    clocking gpio_cb,
    input clk,
    rst_n
  );

  // Modport for GPIO monitor
  modport gmonitor (
    clocking gmonitor_cb,
    input clk,
    rst_n
  );
  */


endinterface   
