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

entity top_async_fifo is
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
end top_async_fifo;

architecture str_arch of top_async_fifo is

	
    signal r_ptr_in_s	 : std_logic_vector(DEPTH downto 0);
    signal r_ptr_out_s	 : std_logic_vector(DEPTH downto 0);
    signal w_ptr_in_s 	 : std_logic_vector(DEPTH downto 0);
    signal w_ptr_out_s 	 : std_logic_vector(DEPTH downto 0);
    signal r_addr_i_s  	 : std_logic_vector(DEPTH-1 downto 0);
    signal w_addr_i_s  	 : std_logic_vector(DEPTH-1 downto 0);
    signal full_o_s      : std_logic;
	
	

	component d_p_ram
		generic (data_WIDTH : natural := 16;
				 DEPTH : natural := 4
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
	end component;		

    component read_port_control
        generic (DEPTH : natural := 4);
        port (
            rd_clk_i 	: in std_logic;
            rd_en_i 	: in std_logic;
            rd_rst_i 	: in std_logic;
            wr_ptr_i 	: in std_logic_vector(DEPTH downto 0);
            empty_o 	: out std_logic;
            rd_addr_o 	: out std_logic_vector(DEPTH-1 downto 0);
            rd_ptr_o 	: out std_logic_vector(DEPTH downto 0)
        );
    end component;

    component write_port_control
        generic (DEPTH : natural := 4);
        port (
            wr_clk_i 	: in std_logic;
            rd_ptr_i 	: in std_logic_vector(DEPTH downto 0);
            wr_rst_i 	: in std_logic;
            wr_en_i 	: in std_logic;
            full_o 		: out std_logic;
            wr_addr_o 	: out std_logic_vector(DEPTH-1 downto 0);
            wr_ptr_o 	: out std_logic_vector(DEPTH downto 0)
        );
    end component;

    component synchronizer
        generic (DEPTH : natural := 4);
        port (
            clk_i 	: in std_logic;
            async_i : in std_logic_vector(DEPTH downto 0);
            rst_i 	: in std_logic;
            sync_o 	: out std_logic_vector(DEPTH downto 0)
        );
    end component;
	
	
begin

	--assignment
	rd_addr_o 	<= r_addr_i_s;
	full_o 		<= full_o_s; 
    wr_addr_o 	<= w_addr_i_s;


	fifo_mem: d_p_ram
		generic map (
					DEPTH => 4,
					data_WIDTH => 16
					)
					
		port map (
				  wr_clk_i   => wr_clk_i,
				  wr_data_i  => wr_data_i,
                  wr_addr_i  => w_addr_i_s,
                  rd_addr_i  => r_addr_i_s,
                  wr_en_i    => wr_en_i,
                  rd_data_o  => rd_data_o,
				  full_i     => full_o_s
				 );			

    read_ctrl: read_port_control
        generic map (DEPTH => DEPTH)
        port map (
            rd_clk_i  => rd_clk_i,
            rd_rst_i  => rd_rst_i,
            rd_en_i   => rd_en_i,
            wr_ptr_i  => w_ptr_in_s,
            empty_o   => empty_o,
            rd_ptr_o  => r_ptr_out_s,
            rd_addr_o => r_addr_i_s
        );

    write_ctrl: write_port_control
        generic map (DEPTH => DEPTH)
        port map (
            wr_clk_i  => wr_clk_i,
            wr_rst_i  => wr_rst_i,
            wr_en_i   => wr_en_i,
            rd_ptr_i  => r_ptr_in_s,
            full_o    => full_o_s,
            wr_ptr_o  => w_ptr_out_s,
            wr_addr_o => w_addr_i_s
        );

    sync_w_ptr: synchronizer
        generic map (DEPTH => DEPTH )
        port map (
            clk_i   => wr_clk_i,
            rst_i   => wr_rst_i,
            async_i => w_ptr_out_s,
            sync_o  => w_ptr_in_s
        );

    sync_r_ptr: synchronizer
        generic map (DEPTH => DEPTH )
        port map (
            clk_i   => rd_clk_i,
            rst_i   => rd_rst_i,
            async_i => r_ptr_out_s,
            sync_o  => r_ptr_in_s
        );

end str_arch;





