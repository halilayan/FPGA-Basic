


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_jk is
end tb_jk;

architecture Behavioral of tb_jk is

component jk is
	port(
			J_i 	: in std_logic;
			K_i 	: in std_logic;
			clk_i 	: in std_logic;
			rst_i	: in std_logic;
			Q_o 	: out std_logic	
		);
end component;

signal	SJ   : std_logic := '0';
signal  SK   : std_logic := '0';
signal  Sclk : std_logic := '0';
signal  Srst : std_logic := '0';
signal  SQ_o : std_logic;

constant clk_period :time := 10ns;

begin

uut: jk port map (
					J_i 	=> SJ,
					K_i 	=> SK,
					clk_i 	=> Sclk,
					rst_i	=> Srst,
					Q_o 	=> SQ_o
				);


clk_i_process : process
					begin
						Sclk <= '0';
						wait for clk_period/2;
						Sclk <= '1';
						wait for clk_period/2;
				end process;
			
--Test
	process
		begin
			Srst <= '1';
			wait for clk_period;
			Srst <= '0';
			wait for 2*clk_period;
			
			SJ <= '0';
			SK <= '0';
			wait for 2*clk_period;
			
			SJ <= '0';
			SK <= '1';
			wait for 2*clk_period;
			
			SJ <= '1';
			SK <= '0';
			wait for 2*clk_period;
			
			SJ <= '1';
			SK <= '1';
			wait for 2*clk_period;
		
	end process;		

end Behavioral;
