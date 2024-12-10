----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Halil İbrahim Ayan
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: sync_fifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 1.0
-- Description: This is a simple syncronous FIFO. 16 pieces of 8-bit data can be written to this fifo.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
	
entity sync_fifo is

	generic (
				fifo_width		:	natural := 8;
				fifo_depth		: 	integer := 16			
			);

	port (
			d_in_i	: in std_logic_vector ((fifo_width - 1) downto 0);
			wr_en_i : in std_logic;
			rd_en_i	: in std_logic;
			clk_i	: in std_logic;
			rst_i	: in std_logic;
			d_out_o	: out std_logic_vector ((fifo_width - 1) downto 0);
			full_o	: out std_logic;
			empty_o	: out std_logic
		);

end sync_fifo;


architecture Behavioral of sync_fifo is

type fifo_array_type is array (0 to fifo_depth - 1) of std_logic_vector (fifo_width - 1 downto 0);
signal s_fifo_array 	: fifo_array_type := (others =>(others => '0'));
signal s_wr_index		: integer range 0 to fifo_depth - 1 := 0;
signal s_rd_index		: integer range 0 to fifo_depth - 1 := 0;
signal s_data_count		: integer range -1 to fifo_depth + 1 := 0;
signal s_full			: std_logic;
signal s_empty 			: std_logic;

begin

	process (clk_i, rst_i)

	begin
			if rst_i = '1' then
				s_data_count	<= 0;
				s_wr_index	<= 0;
				s_rd_index	<= 0;
			elsif rising_edge (clk_i) then
				case std_logic_vector'(wr_en_i & rd_en_i) is
				
					when "00" =>
						null;
					
					--read
					when "01" => 
						if s_data_count > 0 then
							s_data_count <= s_data_count - 1;
							--s_fifo_array(s_rd_index) <= (others => '0');
							s_rd_index <= (s_rd_index + 1) mod fifo_depth;
						end if;
					
					--write
					when "10" =>
						if s_data_count < fifo_depth then
								s_fifo_array(s_wr_index) <= d_in_i;
								s_data_count <= s_data_count + 1;
								s_wr_index <= (s_wr_index + 1) mod fifo_depth;
						end if;
						
					--read & write
					when "11" =>
						if s_data_count < fifo_depth and s_data_count > 0 then
								s_fifo_array(s_wr_index) <= d_in_i;
								--s_fifo_array(s_rd_index) <= (others => '0');
								s_wr_index <= (s_wr_index + 1) mod fifo_depth;
								s_rd_index <= (s_rd_index + 1) mod fifo_depth;
						end if;		
					
					when others =>
						null;
				end case;
			end if;
	end process;
	
	d_out_o <= s_fifo_array(s_rd_index) when (s_data_count > 0) else (others => '0');
	s_full <= '1' when s_data_count = fifo_depth else '0';
	s_empty <= '1' when s_data_count = 0 else '0';
	
	full_o <= s_full;
	empty_o <= s_empty;

end Behavioral;
