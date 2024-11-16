library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_register_16bit is
end tb_register_16bit;

architecture Behavioral of tb_register_16bit is
    
    component register_16bit is
        Port (
            clk   	  : in  STD_LOGIC;
            rst    	  : in  STD_LOGIC;
            en_i      : in  STD_LOGIC;
            d_i       : in  STD_LOGIC_VECTOR(7 downto 0);
            q_o       : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
   
    signal s_clk     : STD_LOGIC := '0';
    signal s_rst     : STD_LOGIC := '0';
    signal s_en      : STD_LOGIC := '0';
    signal s_d       : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal s_q       : STD_LOGIC_VECTOR(15 downto 0);
    
    constant clk_period : time := 10 ns;

begin
    
    uut: register_16bit
        port map (
            clk => s_clk,
            rst => s_rst,
            en_i  => s_en,
            d_i   => s_d,
            q_o   => s_q
        );
    
    clk_process: process
    begin
        s_clk <= '0';
        wait for clk_period / 2;
        s_clk <= '1';
        wait for clk_period / 2;
    end process;
   
    stimulus_process: process
    begin
        
        s_rst <= '1';  
        s_en <= '0';   
        s_d <= "00000000"; 
        wait for clk_period * 2;
       
        s_rst <= '0';
        wait for clk_period ;
       
        s_en <= '1';   
        s_d <= "10101010"; 
        wait for clk_period ;
        
        s_en <= '1';
		s_d <= "11001100"; 
        wait for clk_period ;
        
        s_en <= '0';
        s_d <= "11110000"; 
        wait for clk_period * 2;
        
        s_rst <= '1';
        wait for clk_period * 2;
        
        wait;
    end process;

end Behavioral;
