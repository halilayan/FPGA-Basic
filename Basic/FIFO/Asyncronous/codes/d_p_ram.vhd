----------------------------------------------------------------------------------
 
-- Engineer: Halil Ibrahim Ayan
-- Module Name: top_async_fifo - Behavioral
-- Project Name: asyncron fifo
-- Revision 0.01 - File Created

-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_p_ram is

    generic (	data_WIDTH 	: natural ;
				DEPTH 		: natural 			
			);	
	 port (
        wr_clk_i 	: in std_logic;
		wr_data_i 	: in std_logic_vector(data_WIDTH-1 downto 0);
		wr_addr_i	: in std_logic_vector(DEPTH-1 downto 0);
		rd_addr_i	: in std_logic_vector(DEPTH-1 downto 0);
        wr_en_i 	: in std_logic;
		rd_data_o 	: out std_logic_vector(data_WIDTH-1 downto 0);
		full_i 		: in std_logic
    );		

end d_p_ram;


architecture str_arch of d_p_ram is

type d_p_ram is array (0 to 2**DEPTH-1) of std_logic_vector(data_WIDTH-1 downto 0);
signal ram: d_p_ram;
signal notfull_s: std_logic;

begin
	process(wr_clk_i)
	begin
		if (wr_clk_i'event and wr_clk_i = '1') then
			if (notfull_s = '1') then
				ram(to_integer(unsigned(wr_addr_i))) <= wr_data_i;
			end if;
		end if;
		rd_data_o <= ram(to_integer(unsigned(rd_addr_i)));
	end process;
	
	notfull_s <= wr_en_i and not full_i;

end str_arch;	