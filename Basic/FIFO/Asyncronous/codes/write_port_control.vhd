----------------------------------------------------------------------------------
 
-- Engineer: Halil Ibrahim Ayan
-- Module Name: top_async_fifo - Behavioral
-- Project Name: asyncron fifo
-- Revision 0.01 - File Created

-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity write_port_control is
    generic (DEPTH: natural := 4
			);
    port (
        wr_clk_i    : in std_logic;
        wr_rst_i 	: in std_logic;
        wr_en_i     : in std_logic;
        rd_ptr_i 	: in std_logic_vector(DEPTH downto 0);
        wr_ptr_o 	: out std_logic_vector(DEPTH downto 0);
        wr_addr_o   : out std_logic_vector(DEPTH-1 downto 0);
        full_o      : out std_logic
    );
end write_port_control;

architecture gray_arch of write_port_control is
    signal w_ptr_reg_s    : std_logic_vector(DEPTH downto 0);
    signal w_ptr_next_s   : std_logic_vector(DEPTH downto 0);
    signal gray_s         : std_logic_vector(DEPTH downto 0);
    signal bin_s          : std_logic_vector(DEPTH downto 0);
    signal bin1_s         : std_logic_vector(DEPTH downto 0);
    signal w_addr_msb_s   : std_logic;
    signal r_addr_msb_s   : std_logic;
    signal full_flag_s    : std_logic;
    
begin
    process (wr_clk_i, wr_rst_i)
    begin
        if (wr_rst_i = '1') then
            w_ptr_reg_s <= (others => '0');        
        elsif (rising_edge(wr_clk_i)) then
			w_ptr_reg_s <= w_ptr_next_s;
		end if;	
	end process;
	
    -- binary to gray
	bin_s 	<= w_ptr_reg_s xor ('0' & bin_s (DEPTH downto 1));
    bin1_s 	<= std_logic_vector(unsigned(bin_s) + 1); 
    gray_s <= bin1_s xor ('0' & bin1_s(DEPTH downto 1));
    
               
    
    -- Update write pointer
    w_ptr_next_s <= gray_s when (wr_en_i = '1' and full_flag_s = '0') else			 
	w_ptr_reg_s;

    
	--DEPTH (full belirlenmesi icin)
	w_addr_msb_s <= w_ptr_reg_s(DEPTH) xor w_ptr_reg_s(DEPTH-1); 


    -- Check for FIFO full_o
    r_addr_msb_s <= rd_ptr_i(DEPTH) xor rd_ptr_i(DEPTH-1);
    full_flag_s  <= '1' when rd_ptr_i(DEPTH) /= w_ptr_reg_s(DEPTH) and						
						   rd_ptr_i(DEPTH-2 downto 0) = w_ptr_reg_s (DEPTH-2 downto 0) and						
						   r_addr_msb_s = w_addr_msb_s else						
				    '0';

					
    -- Outputs 
    wr_addr_o <= bin_s(DEPTH-1 downto 0);
    wr_ptr_o  <= w_ptr_reg_s;
    full_o    <= full_flag_s;

end gray_arch;


