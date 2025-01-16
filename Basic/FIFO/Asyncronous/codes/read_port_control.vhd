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

entity read_port_control is
    generic (DEPTH : natural := 4
			);
    port (
        rd_clk_i 	: in std_logic;
        rd_rst_i 	: in std_logic;
        wr_ptr_i    : in std_logic_vector(DEPTH downto 0);
        rd_en_i     : in std_logic;
        rd_ptr_o	: out std_logic_vector(DEPTH downto 0);
        rd_addr_o   : out std_logic_vector(DEPTH-1 downto 0);
        empty_o     : out std_logic
    );
end read_port_control;

architecture gray_arch of read_port_control is
    signal r_ptr_reg_s 		: std_logic_vector(DEPTH downto 0);
    signal r_ptr_next_s 	: std_logic_vector(DEPTH downto 0);
    signal gray_s      		: std_logic_vector(DEPTH downto 0);
    signal bin_s      		: std_logic_vector(DEPTH downto 0);
    signal bin1_s      		: std_logic_vector(DEPTH downto 0);
    signal empty_flag_s   	: std_logic;
    signal raddr_msb_s 		: std_logic;
    signal waddr_msb_s  	: std_logic;
begin

    -- Register process
    process (rd_clk_i, rd_rst_i)
    begin
        if rd_rst_i = '1' then
            r_ptr_reg_s <= (others => '0');
        elsif rising_edge(rd_clk_i) then
            r_ptr_reg_s <= r_ptr_next_s;
        end if;
    end process;

    -- binary to gray
    bin_s   <= r_ptr_reg_s xor ('0' & bin_s(DEPTH downto 1));
    bin1_s  <= std_logic_vector(unsigned(bin_s) + 1);
    gray_s <= bin1_s xor ('0' & bin1_s(DEPTH downto 1));


    -- Update read pointer
    r_ptr_next_s <= gray_s when rd_en_i = '1' and empty_flag_s = '0' else 
				  r_ptr_reg_s;


    -- DEPTH-bit Gray counter(empty sinyali icin)
    raddr_msb_s  <= r_ptr_reg_s(DEPTH) xor r_ptr_reg_s(DEPTH-1);
    waddr_msb_s  <= wr_ptr_i(DEPTH) xor wr_ptr_i(DEPTH-1);


    -- Check for FIFO empty_o
    empty_flag_s <= '1' when wr_ptr_i(DEPTH) = r_ptr_reg_s(DEPTH) and
						   wr_ptr_i(DEPTH-2 downto 0) = r_ptr_reg_s(DEPTH-2 downto 0) and
						   raddr_msb_s = waddr_msb_s else
                  '0';


    -- Outputs
    rd_addr_o   <= bin_s(DEPTH-1 downto 0);
    rd_ptr_o    <= r_ptr_reg_s;
    empty_o     <= empty_flag_s;

end gray_arch;
