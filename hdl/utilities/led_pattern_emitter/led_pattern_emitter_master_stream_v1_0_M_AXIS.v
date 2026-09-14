///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// AXI Streaming master interface of the LED color pattern emitter
//
`timescale 1 ns / 1 ps

	module led_pattern_emitter_master_stream_v1_0_M_AXIS #
	(
		// Users to add parameters here
		parameter integer C_NUM_LEDS = 8,
		parameter integer C_PATTERN_LEN = 1,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 1
	)
	(
		// Users to add ports here
		input wire SEND,
        input wire [C_M_AXIS_TDATA_WIDTH*C_PATTERN_LEN-1:0] PATTERN,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire  M_AXIS_ACLK,
		// 
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output wire  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY
	);
	// Total number of output data                                                 
	localparam NUMBER_OF_OUTPUT_WORDS = C_NUM_LEDS;                                               
	                                                                                     
	// function called clogb2 that returns an integer which has the                      
	// value of the ceiling of the log base 2.                                           
	function integer clogb2 (input integer bit_depth);                                   
	  begin                                                                              
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                                      
	      bit_depth = bit_depth >> 1;                                                    
	  end                                                                                
	endfunction                                                                          
	                                                                                     
	// WAIT_COUNT_BITS is the width of the wait counter.                                 
	localparam integer WAIT_COUNT_BITS = clogb2(C_M_START_COUNT-1);                      
	                                                                                     
	// bit_num gives the minimum number of bits needed to address 'depth' size of FIFO.  
	localparam bit_num  = clogb2(NUMBER_OF_OUTPUT_WORDS);                                
	                                                                                     
	// Define the states of state machine                                                
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO                                      
	parameter [1:0] IDLE = 2'b00,        // This is the initial/idle state               
	                                                                                     
	                INIT_COUNTER  = 2'b01, // This state initializes the counter, once   
	                                // the counter reaches C_M_START_COUNT count,        
	                                // the state machine changes state to SEND_STREAM     
	                SEND_STREAM   = 2'b10; // In this state the                          
	                                     // stream data is output through M_AXIS_TDATA   
	// State variable                                                                    
	reg [1:0] mst_exec_state;                                                            
	// Example design FIFO read pointer                                                  
	reg [bit_num-1:0] read_pointer;                                                      

	// AXI Stream internal signals
	//wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
	reg [WAIT_COUNT_BITS-1 : 0] 	count;
	//streaming data valid
	reg  	axis_tvalid;
	//Last of the streaming data 
	reg  	axis_tlast;
	//FIFO implementation signals
	wire [C_M_AXIS_TDATA_WIDTH-1 : 0] 	stream_data_out;

	wire  	tx_en;

	reg [C_M_AXIS_TDATA_WIDTH-1:0] data_rom [C_NUM_LEDS-1:0];

	// I/O Connections assignments

	assign M_AXIS_TVALID = axis_tvalid;
	assign M_AXIS_TDATA	= stream_data_out;
	assign M_AXIS_TLAST	= axis_tlast;
	assign M_AXIS_TSTRB	= {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};


	// Control state machine implementation                             
	always @(posedge M_AXIS_ACLK)                                             
	begin                                                                     
	  if (!M_AXIS_ARESETN)                                                    
	  // Synchronous reset (active low)                                       
	    begin                                                                 
	      mst_exec_state <= IDLE;                                                                                                 
	    end                                                                   
	  else                                                                    
	    case (mst_exec_state)                                                 
	      IDLE:                                                               
	        // The slave starts accepting tdata when                          
	        // there tvalid is asserted to mark the                           
	        // presence of valid streaming data                               
	        if ( SEND == 1'b1)                                                 
	          begin                                                           
	            mst_exec_state  <= INIT_COUNTER;                              
	          end                                                             
	        else                                                              
	          begin                                                           
	            mst_exec_state  <= IDLE;                                      
	          end                                                             
	                                                                          
	      INIT_COUNTER:                                                       
	        // The slave starts accepting tdata when                          
	        // there tvalid is asserted to mark the                           
	        // presence of valid streaming data                               
	        if ( count == C_M_START_COUNT - 1 )                               
	          begin                                                           
	            mst_exec_state  <= SEND_STREAM;                               
	          end                                                             
	        else                                                              
	          begin                                                                                                    
	            mst_exec_state  <= INIT_COUNTER;                              
	          end                                                             
	                                                                          
	      SEND_STREAM:                                                        
	        // The example design streaming master functionality starts       
	        // when the master drives output tdata from the FIFO and the slave
	        // has finished storing the S_AXIS_TDATA                          
	        if (read_pointer == NUMBER_OF_OUTPUT_WORDS - 1 && tx_en)                                                      
	          begin                                                           
	            mst_exec_state <= IDLE;                                       
	          end                                                             
	        else                                                              
	          begin                                                           
	            mst_exec_state <= SEND_STREAM;                                
	          end                                                             
	    endcase                                                               
	end                                                                       

	// State machine outputs                             
	always @(posedge M_AXIS_ACLK)                                             
	begin                                                                     
	  if (!M_AXIS_ARESETN)                                                    
	  // Synchronous reset (active low)                                       
	    begin                                                                 
	      read_pointer <= 1'b0;                                             
	      axis_tvalid <= 1'b0;
		  axis_tlast <= 1'b0;
		  count <= 'b0;                                                     
	    end                                                                   
	  else                                                                    
	    case (mst_exec_state)                                                 
	      IDLE:                                                               
			begin
				read_pointer <= 1'b0;                                             
	      		axis_tvalid <= 1'b0;
		  		axis_tlast <= 1'b0; 
				count <= 'b0;
			end                                    
	                                                                          
	      INIT_COUNTER:                                                       
	        // The slave starts accepting tdata when                          
	        // there tvalid is asserted to mark the                           
	        // presence of valid streaming data                               
	        if ( count < C_M_START_COUNT - 1 )
			begin                                                                                    
	            count <= count + 1;
			end                                               
	                                                                          
	      SEND_STREAM:                                                        
	        begin
				if (tx_en && read_pointer == NUMBER_OF_OUTPUT_WORDS -1)
				begin
					axis_tvalid <= 1'b0;
					axis_tlast <= 1'b0;
				end 
				else begin
					axis_tvalid <= 1'b1;
					if (tx_en) begin
						axis_tlast <= (read_pointer == NUMBER_OF_OUTPUT_WORDS - 2);
						read_pointer <= read_pointer + 1;
					end
				end
			end                                                            
	    endcase                                                               
	end                           

	assign tx_en = M_AXIS_TREADY && M_AXIS_TVALID;   
	assign stream_data_out = data_rom[read_pointer];                                         

	// Add user logic here
	genvar i;
	generate
		for (i = 0; i < C_NUM_LEDS; i++) begin
			assign data_rom[i] = PATTERN[((i % C_PATTERN_LEN)+1)*C_M_AXIS_TDATA_WIDTH-1 : (i % C_PATTERN_LEN)*C_M_AXIS_TDATA_WIDTH];
		end
	endgenerate

	// User logic ends

	endmodule
