
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_dlatch is
end tb_dlatch;


architecture Behavioral of tb_dlatch is

component dlatch is
	 Port (
		   D_i 		: in STD_LOGIC;
           E_i 		: in STD_LOGIC;
           clk_i 	: in STD_LOGIC;
           rst_i 	: in STD_LOGIC;
           Q_o 		: out STD_LOGIC
           );
end component;

signal SD_i 		: std_logic := '0' ;	 
signal SE_i 	    : std_logic := '0' ;
signal Sclk_i   	: std_logic := '0' ;
signal Srst_i    	: std_logic := '0' ;
signal SQ_o 	    : std_logic := '0' ;

constant clk_period :time := 10ns;

begin

uut: dlatch port map (
						D_i 	=> SD_i,
                        E_i 	=> SE_i,
                        clk_i   => Sclk_i,
					    rst_i   => Srst_i,
					    Q_o 	=> SQ_o
					);
					
					
clk_i_process: 	process
					begin
						Sclk_i <= '0';
						wait for clk_period/2;
						Sclk_i <= '1';
						wait for clk_period/2;
				end process;
--Test

ED_in: 	process
			begin	
				Srst_i <= '1';
				wait for clk_period*2;
				Srst_i <= '0';
				wait for clk_period*2;
				
				SE_i <= '0';
				SD_i <= '0';
				wait for clk_period*2;
				SE_i <= '0';
				SD_i <= '1';
				wait for clk_period*2;
				SE_i <= '1';
				SD_i <= '0';
				wait for clk_period*2;
				SE_i <= '1';
				SD_i <= '1';
				wait for clk_period*2;
			
		end process ED_in;
end Behavioral;
