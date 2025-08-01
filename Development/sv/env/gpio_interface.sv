//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : gpio_interface.sv                                                  #
//----COMPONENT    : GPIO INTERFACE                                                     #  
//----DESCRIPTION  : interface can be re-used for other projects Also it becomes        #
//----               easier to connect with the DUT and other verification components.  #
//----CREATED_ON   : 21/07/2025                                                         #                                             
//----CREATED_BY   : Dipali                                                             #
//#######################################################################################
interface gpio_if (input logic clk, input logic rst_n);   
  //GPIO Block Signals
  logic [`DATA_WIDTH-1:0] gpio_in;    // External input to DUT   

  logic [`DATA_WIDTH-1:0] gpio_out;   // Output from DUT   

  logic [`DATA_WIDTH-1:0] gpio_intr;  // Interrupts 

  string inst_name = $sformatf("%m");
  function print();
    $display("getting interface : %s",inst_name);
  endfunction

  initial begin
    virtual gpio_if gvif;
    gvif = interface::self();
    uvm_config_db#(virtual gpio_if)::set(null,inst_name,"gvif",gvif);
  end

  
  //clocking block for gpio
  clocking gpio_cb @(posedge clk);
    default input #0 output #0;
    output gpio_in;
    input gpio_out,gpio_intr;
  endclocking:gpio_cb

  //clocking block for monitor
  clocking gmonitor_cb @(posedge clk);
    default input #0;
    input gpio_in,gpio_out,gpio_intr;
  endclocking:gmonitor_cb

  //modport for gpio and monitor
  modport gpio (clocking gpio_cb,input clk,rst_n);
  modport gmonitor (clocking gmonitor_cb,input clk,rst_n);



endinterface   
