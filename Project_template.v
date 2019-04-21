	module ASM (input clk,
    input rst,
    input clr,
    input ent,
    input change,
	output reg [5:0] led,
	output reg [19:0] ssd,
	output [3:0]AN,
	output [6:0] seven_out,
    input [3:0] sw
	 ); 

//registers
 reg [15:0] password;
 reg [15:0] inpassword;
 reg [5:0] current_state;
 reg [5:0] next_state;

// parameters for States, you will need more states obviously
parameter LOCKED = 6'b000000; //idle state 
parameter GETFIRSTDIGIT_LOCKED  = 6'b000001; // get_first_input_state // this is not a must, one can use counter instead of having another step, design choice
parameter GETSECONDDIGIT_LOCKED  = 6'b000010; //get_second input state
parameter GETTHIRDDIGIT_LOCKED  = 6'b000011;
parameter GETFOURTHDIGIT_LOCKED = 6'b000100;
parameter UNLOCKED = 6'b000101; // locked state
parameter GETFIRSTDIGIT_UNLOCKED  = 6'b000110; // get_first_input_state // this is not a must, one can use counter instead of having another step, design choice
parameter GETSECONDDIGIT_UNLOCKED  = 6'b000111; //get_second input state
parameter GETTHIRDDIGIT_UNLOCKED	 = 6'b001000;
parameter GETFOURTHDIGIT_UNLOCKED = 6'b001001;

// parameters for output, you will need more obviously
parameter C = 5'b01010; // you should decide on what should be the value of C, the answer depends on your binary_to_segment file implementation
parameter L = 5'b01011; // same for L and for other guys, each of them 5 bit. IN ssd module you will provide 20 bit input, each 5 bit will be converted into 7 bit SSD in binary to segment file.
parameter S = 5'b01100;
parameter d = 5'b01101;
parameter O = 5'b01110;		
parameter P = 5'b01111; 
parameter E = 5'b10000;
parameter n = 5'b10001;
parameter tire = 5'b10010;
parameter blank = 5'b10011;
//parameter CHANGING = 5'b10100; // make cases for this
reg CHANGING = 0;

wire ent_out;
wire clr_out;
wire change_out;

//wire deb_clock;
	
// debouncer
//clk_divider clkdivDEB(clk, rst, deb_clock);
debouncer bounce_ent(clk, rst, ent, ent_out);
debouncer bounce_clr(clk, rst, clr, clr_out);
debouncer bounce_change(clk, rst, change, change_out);

//Sequential part for state transitions
	always @ (posedge clk or posedge rst)
	begin
		// your code goes here
		if(rst==1) begin
		current_state <= LOCKED;
		end
		else
			begin
		current_state <= next_state;
			end
	end
	

	// combinational part - next state definitions
	always @ (*)
	begin
		led = current_state;

	// LOCKED MODE
		if(current_state == LOCKED)
		begin
		CHANGING = 0; // make sure changing is reset
			//assign password[15:0]=16'b0000000000000000;
			// your code goes here
			if(ent_out == 1)
				next_state = GETFIRSTDIGIT_LOCKED;
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_LOCKED;
			else 
				next_state = current_state;
		end

		else if ( current_state == GETFIRSTDIGIT_LOCKED ) begin
			 if (ent_out == 1)
			 	next_state = GETSECONDDIGIT_LOCKED;
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_LOCKED;
			 else
			 	next_state = current_state;
		end
		
		else if (current_state == GETSECONDDIGIT_LOCKED) begin
			if (ent_out == 1)
				next_state = GETTHIRDDIGIT_LOCKED;
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_LOCKED;
			else
				next_state = current_state;
		end
		
		else if(current_state == GETTHIRDDIGIT_LOCKED) begin
			if (ent_out == 1) 
				next_state = GETFOURTHDIGIT_LOCKED;
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_LOCKED;
			else
				next_state = current_state;
		end
		
		else if(current_state == GETFOURTHDIGIT_LOCKED) begin
			if (ent_out == 1) begin
				if (password == inpassword) 
					next_state = UNLOCKED;
				else
					next_state = LOCKED;
			end
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_LOCKED;
			else
				next_state = current_state;
		end
	
	// UNLOCKED MODE
		else if(current_state == UNLOCKED) begin
			CHANGING = 0;
			if(ent_out == 1)
				next_state = GETFIRSTDIGIT_UNLOCKED;
			else if (change_out == 1) begin
				CHANGING = 1;
				next_state = GETFIRSTDIGIT_UNLOCKED;
			end
			else if (clr_out == 1) begin
				next_state = GETFIRSTDIGIT_UNLOCKED;
			end
			else
				next_state = current_state;
		end

		else if (current_state == GETFIRSTDIGIT_UNLOCKED) begin
			 if (ent_out == 1)
			 	next_state = GETSECONDDIGIT_UNLOCKED;
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_UNLOCKED;
			 else
			 	next_state = current_state;
		end
		
		else if (current_state == GETSECONDDIGIT_UNLOCKED) begin
			if (ent_out == 1)
				next_state = GETTHIRDDIGIT_UNLOCKED;
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_UNLOCKED;
			else
				next_state = current_state;
		end
		
		else if(current_state == GETTHIRDDIGIT_UNLOCKED) begin
			if (ent_out == 1)
				next_state = GETFOURTHDIGIT_UNLOCKED;
			else if (clr_out == 1)
				next_state = GETFIRSTDIGIT_UNLOCKED;
			else
				next_state = current_state; // forcing, let's see
		end
		
		else if(current_state == GETFOURTHDIGIT_UNLOCKED) begin // no clear case because that fucks it up lol
			if (ent_out == 1) begin
				if (CHANGING == 1) begin
					next_state = UNLOCKED;
					//CHANGING = 0;
				end
				else if (password == inpassword) begin
					next_state = LOCKED;
				end
				else if (password != inpassword) begin
					next_state = UNLOCKED;
				end
			end
		else begin end
		end
	end


	//Sequential part for control registers, this part is responsible from assigning control registers or stored values
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			inpassword[15:0] <= 16'b0000000000000000; 
			password[15:0] <= 16'b0000000000000000; // HARD CODED FOR TESTING, MUST CHANGE
		end

		else begin
			if(current_state == LOCKED)
			begin
			 	//password[15:0] <= 16'b0000000000000000; // Built in reset is 0, when user in LOCKED state.
				 // you may need to add extra things here.
			end
		
			else if(current_state == GETFIRSTDIGIT_LOCKED)
			begin
				if(ent_out == 1)
					inpassword[15:12] <= sw[3:0]; // inpassword is the password entered by user, first 4 digits will be equal to current switch values
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state = LOCKED;
				end
				else begin
				end
			end

			else if (current_state == GETSECONDDIGIT_LOCKED)
			begin
				if(ent_out == 1)
					inpassword[11:8] <= sw[3:0]; // inpassword is the password entered by user, second 4 digit will be equal to current switch values
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state = LOCKED;
				end
				else begin
				end
			end
			
			else if (current_state == GETTHIRDDIGIT_LOCKED) 
			begin
				if (ent_out == 1)
					inpassword[7:4] <= sw[3:0];
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state <= LOCKED;
				end
				else begin
				end
			end
			
			else if (current_state == GETFOURTHDIGIT_LOCKED)
			begin
				if (ent_out == 1) begin
					inpassword[3:0] <= sw[3:0];
				end
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state <= LOCKED;
				end
				else begin
				end
			end
			
			else if (current_state == UNLOCKED) begin
				// do nothing
			end
			
			else if (current_state == GETFIRSTDIGIT_UNLOCKED) begin
				if(ent_out == 1)
					inpassword[15:12] <= sw[3:0]; // inpassword is the password entered by user, first 4 digin will be equal to current switch values
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state <= UNLOCKED;
				end
				else begin
				end
			end
			
			else if (current_state == GETSECONDDIGIT_UNLOCKED)
			begin
				if(ent_out ==1)
					inpassword[11:8] <= sw[3:0]; // inpassword is the password entered by user, second 4 digit will be equal to current switch values
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state <= UNLOCKED;
				end
				else begin
				end
			end
			
			else if (current_state == GETTHIRDDIGIT_UNLOCKED) 
			begin
				if (ent_out == 1)
					inpassword[7:4] <= sw[3:0];
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state <= UNLOCKED;
				end
				else begin
				end
			end
			
			else if (current_state == GETFOURTHDIGIT_UNLOCKED)
			begin
				if (ent_out == 1)
					inpassword[3:0] <= sw[3:0];
					if (CHANGING == 1) begin
						password <= inpassword;
					end
				else if (clr_out == 1) begin
					inpassword[15:0] <= 16'b0000000000000000;
					//next_state <= UNLOCKED;
				end
				else begin
				end
			end
			else begin
			end
		end
	end		


		/*

		Complete the rest of ASM chart, in this section, you are supposed to set the values for control registers, stored registers(password for instance)
		number of trials, counter values etc... 

		*/


	// Sequential part for outputs; this part is responsible from outputs; i.e. SSD and LEDS
		// SEVEN_SEGMENT
	seven_segment SSD(clk, rst, ssd, AN, seven_out);
	
	always @(posedge clk)
	begin
	
		if(current_state == LOCKED)
		begin
			ssd <= {C, L, S, d};	//CLSd
		end

		else if(current_state == GETFIRSTDIGIT_LOCKED)
		begin
			ssd <= {1'b0, sw[3:0], blank, blank, blank};	// you should modify this part slightly to blink it with 1Hz. The 0 is at the beginning is to complete 4bit SW values to 5 bit.
		end

		else if(current_state == GETSECONDDIGIT_LOCKED)
		begin
			ssd <= { tire , 1'b0, sw[3:0], blank, blank};	// you should modify this part slightly to blink it with 1Hz. 0 after tire is to complete 4 bit sw to 5 bit. Padding 4 bit sw with 0 in other words.	
		end
		
		else if (current_state == GETTHIRDDIGIT_LOCKED) begin
			ssd <= {tire, tire, 1'b0, sw[3:0], blank};
		end
		
		else if (current_state == GETFOURTHDIGIT_LOCKED) begin
			ssd <= {tire, tire, tire, 1'b0 ,sw[3:0]};
		end
		
		else if (current_state == UNLOCKED) begin
			ssd <= {O, P, E, n}; //OPEn
		end
		
		else if (current_state == GETFIRSTDIGIT_UNLOCKED) begin
			if (CHANGING == 1)
				ssd <= { 1'b0, sw[3:0], blank, blank, blank};
			else
				ssd <= { 1'b0, sw[3:0], blank, blank, blank};
		end
		
		else if (current_state == GETSECONDDIGIT_UNLOCKED) begin
			if (CHANGING == 1)
				ssd <= { 1'b0, inpassword[15:12], 1'b0, sw[3:0], blank, blank};
			else
				ssd <= { tire , 1'b0 , sw[3:0], blank, blank};
		end
		
		else if (current_state == GETTHIRDDIGIT_UNLOCKED) begin
			if (CHANGING == 1)
				ssd <= { 1'b0, inpassword[15:12], 1'b0,inpassword[11:8], 1'b0, sw[3:0], blank};
			else
				ssd <= { tire , tire, 1'b0, sw[3:0], blank};
		end
		
		else if (current_state == GETFOURTHDIGIT_UNLOCKED) begin
			if (CHANGING == 1)
				ssd <= {1'b0,inpassword[15:12], 1'b0,inpassword[11:8], 1'b0, inpassword[7:4], 1'b0, sw[3:0]};
			else
				ssd <= { tire , tire, tire, 1'b0, sw[3:0]};
		end
		else begin
		end
	end


endmodule
