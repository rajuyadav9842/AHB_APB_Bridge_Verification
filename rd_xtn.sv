class read_xtn extends uvm_sequence_item;
  `uvm_object_utils(read_xtn)
 bit [31:0] Prdata;
bit [31:0] Pwdata;
bit [31:0] Paddr;
bit Pwrite;
 function new(string name="read_xtn");
    super.new(name);
     endfunction

extern function void do_print(uvm_printer printer);

endclass
function void  read_xtn::do_print (uvm_printer printer);
    super.do_print(printer);

   
    //                   srting name   		bitstream value     size       radix for printing
    printer.print_field( "Pwdata", 		this.Pwdata, 	    32,		 UVM_HEX		);
    printer.print_field( "Prdata",               this.Prdata,       32,           UVM_HEX              );
    printer.print_field( "Paddr",               this.Paddr,       32,           UVM_DEC              );
     printer.print_field( "Pwrite",               this.Pwrite,       1,           UVM_DEC              );


 endfunction
