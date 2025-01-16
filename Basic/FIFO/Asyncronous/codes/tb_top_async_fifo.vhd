----------------------------------------------------------------------------------
 
-- Engineer: Halil Ibrahim Ayan
-- Module Name: top_async_fifo - Behavioral
-- Project Name: asyncron fifo
-- Revision 0.01 - File Created

-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity tb_top_async_fifo is
end tb_top_async_fifo;

architecture Behavioral of tb_top_async_fifo is

	constant data_WIDTH : natural := 16;
	constant DEPTH		: natural := 4;
	
	--clock periods
	constant w_clk_period : time := 10ns;
	constant r_clk_period : time := 20ns;
	
	
	

	signal wr_clk_i 	: std_logic;
	signal wr_rst_i    	: std_logic; 	
	signal wr_en_i    	: std_logic; 	
	signal full_o     	: std_logic;		
	signal wr_data_i  	: std_logic_vector (data_WIDTH-1 downto 0);
	signal rd_clk_i    	: std_logic; 	
	signal rd_rst_i    	: std_logic; 	
	signal rd_en_i 	  	: std_logic;	
	signal rd_data_o	: std_logic_vector (data_WIDTH-1 downto 0);
	signal empty_o 	  	: std_logic;
	signal wr_addr_o   	: std_logic_vector (DEPTH-1 downto 0);	
	signal rd_addr_o   	: std_logic_vector (DEPTH-1 downto 0);	
		
	
	
	component top_async_fifo
		generic (	data_WIDTH 	: natural := 16;
					DEPTH 		: natural := 4	
				);
		port (
			--write
			wr_clk_i 	: in std_logic;
			wr_rst_i 	: in std_logic;
			wr_en_i 	: in std_logic;
			full_o 		: out std_logic;
			wr_data_i	: in std_logic_vector(data_WIDTH-1 downto 0);
			
			--read
			rd_clk_i 	: in std_logic;
			rd_rst_i 	: in std_logic;
			rd_en_i 	: in std_logic;
			rd_data_o	: out std_logic_vector(data_WIDTH-1 downto 0);
			empty_o 	: out std_logic;
			
			wr_addr_o 	: out std_logic_vector(DEPTH-1 downto 0);
			rd_addr_o 	: out std_logic_vector(DEPTH-1 downto 0)
			
				
			);
	
	end component;


begin

ins_top_async : top_async_fifo
	generic map(
				data_WIDTH 	=> data_WIDTH,
	            DEPTH 		=> DEPTH
				)
	port map	(
				
				wr_clk_i 	=> wr_clk_i,
				wr_rst_i 	=> wr_rst_i,
				wr_en_i 	=> wr_en_i,
				full_o 		=> full_o,
				wr_data_i	=> wr_data_i,
				rd_clk_i 	=> rd_clk_i,
				rd_rst_i 	=> rd_rst_i,
				rd_en_i 	=> rd_en_i,
				rd_data_o	=> rd_data_o,
				empty_o 	=> empty_o,
				wr_addr_o 	=> wr_addr_o,
				rd_addr_o 	=> rd_addr_o	
	            
				);


	--write clock
write_clock_process: process 
						begin
							wr_clk_i <= '1';
							wait for w_clk_period/2;
							wr_clk_i <= '0';
							wait for w_clk_period/2;
					 end process; 

	--read clock
read_clock_process: process
						begin
							rd_clk_i <= '1';
							wait for r_clk_period/2;
							rd_clk_i <= '0';	
							wait for r_clk_period/2;		
					end process;
					

	--test
uut_process:		process
						begin	
							wr_rst_i <= '1';
							rd_rst_i <= '1';
							wr_en_i <= '0';
							rd_en_i <= '0';
							wait for 20ns;
							
							wr_rst_i <= '0';
							rd_rst_i <= '0';
							wait for 5ns;
							
							--write
							wr_en_i <= '1';
							wr_data_i <= x"0A00";
							wait for w_clk_period;
							wr_data_i <= x"1B25";
							wait for w_clk_period;
							wr_data_i <= x"3CF2";
							wait for w_clk_period;
							wr_data_i <= x"076A";
							wait for w_clk_period;
							wr_data_i <= x"4B01";
							wait for w_clk_period;
							wr_data_i <= x"2FF3";
							wait for w_clk_period;
							wr_data_i <= x"0D7A";
							wait for w_clk_period;
							wr_data_i <= x"7A0c";
							wait for w_clk_period;
							
							wr_en_i <= '1';
							wr_data_i <= x"0A10";
							wait for w_clk_period;
							wr_data_i <= x"1B28";
							wait for w_clk_period;
							wr_data_i <= x"2CF2";
							wait for w_clk_period;
							wr_data_i <= x"076B";
							wait for w_clk_period;
							wr_data_i <= x"4A01";
							wait for w_clk_period;
							wr_data_i <= x"2F33";
							wait for w_clk_period;
							wr_data_i <= x"2D7A";
							wait for w_clk_period;
							wr_data_i <= x"9A0c";
							wait for w_clk_period;
							
							wr_en_i <= '0';
							wait for w_clk_period*5;
							
							--read
							rd_en_i <= '1';
							wait for r_clk_period*20;
							
							wr_en_i <= '1';
							rd_en_i <= '1';
							wr_data_i <= x"0A00";
							wait for w_clk_period;
							wr_data_i <= x"1B25";
							wait for w_clk_period;
							wr_data_i <= x"3CF2";
							wait for w_clk_period;
							wr_data_i <= x"076A";
							wait for w_clk_period;
							wr_data_i <= x"4B01";
							wait for w_clk_period;
							wr_data_i <= x"2FF3";
							wait for w_clk_period;
							wr_data_i <= x"0D7A";
							wait for w_clk_period;
							wr_data_i <= x"7A0c";
							wait for w_clk_period;
							
							
							wr_data_i <= x"0A10";
							wait for w_clk_period;
							wr_data_i <= x"1B28";
							wait for w_clk_period;
							wr_data_i <= x"2CF2";
							wait for w_clk_period;
							wr_data_i <= x"076B";
							wait for w_clk_period;
							wr_data_i <= x"4A01";
							wait for w_clk_period;
							wr_data_i <= x"2F33";
							wait for w_clk_period;
							wr_data_i <= x"2D7A";
							wait for w_clk_period;
							wr_data_i <= x"9A0c";
							wait for w_clk_period;
							
							
							
							rd_en_i <= '0';
							wr_en_i <= '0';
							
							wait for r_clk_period*10;
							wait;
					end process;
	
end Behavioral;
