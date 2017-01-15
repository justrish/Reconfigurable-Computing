library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    generic (
        WIDTH : positive := 8);
    port (
        clk : in std_logic;
        rst : in std_logic;

        -- control inputs
		i_sel     : in std_logic;
        x_sel     : in std_logic;
        y_sel     : in std_logic;
		i_ld      : in std_logic;
        x_ld      : in std_logic;
        y_ld      : in std_logic;
		n_ld      : in std_logic;
        result_ld : in std_logic;
        
        -- control outputs
        i_le_n : out std_logic;

        -- I/O 
        n      : in  std_logic_vector(WIDTH-1 downto 0);
        result : out std_logic_vector(WIDTH-1 downto 0));
end datapath;

architecture STR of datapath is
    signal x_mux_out, y_mux_out, i_mux_out				: std_logic_vector(width-1 downto 0);
    signal x_reg_out, y_reg_out, i_reg_out, n_reg_out	: std_logic_vector(width-1 downto 0);
    signal i_inc_out, x_y_add_out 						: std_logic_vector(width-1 downto 0);
begin
	
	U_I_MUX : entity work.mux_2x1(BHV)
        generic map (width => width)
        port map (
            in1    => std_logic_vector(to_unsigned(3,width)),
            in2    => i_inc_out,
            sel    => i_sel,
            output => i_mux_out
            );
	
    U_X_MUX : entity work.mux_2x1(BHV)
        generic map (width => width)
        port map (
            in1    => std_logic_vector(to_unsigned(1,width)),
            in2    => y_reg_out,
            sel    => x_sel,
            output => x_mux_out
            );

    U_Y_MUX : entity work.mux_2x1(BHV)
        generic map (width => width)
        port map (
            in1    => std_logic_vector(to_unsigned(1,width)),
            in2    => x_y_add_out,
            sel    => y_sel,
            output => y_mux_out
            );

    U_N_REG : entity work.reg(BHV)
        generic map(width => width)
        port map (clk    => clk,
				  rst    => rst,
                  ld	 => n_ld,
                  input  => n,
                  output => n_reg_out
                  );

    U_I_REG : entity work.reg(BHV)
        generic map(width => width)
        port map (clk    => clk,
                  rst    => rst,
                  ld     => i_ld,
                  input  => i_mux_out,
                  output => i_reg_out
                  );

    U_X_REG : entity work.reg(BHV)
        generic map(width => width)
        port map (clk    => clk,
                  rst    => rst,
                  ld     => x_ld,
                  input  => x_mux_out,
                  output => x_reg_out
                  );

    U_Y_REG : entity work.reg(BHV)
        generic map(width => width)
        port map (clk    => clk,
                  rst    => rst,
                  ld     => y_ld,
                  input  => y_mux_out,
                  output => y_reg_out
                  );

    U_X_ADD_Y : entity work.add(BHV)
        generic map (width => width)
        port map (in1    => y_reg_out,
                  in2    => x_reg_out,
                  output => x_y_add_out
				  );
	
	U_I_INC : entity work.add(BHV)
    generic map (width => width)
    port map (in1    => std_logic_vector(to_unsigned(1,width)),
              in2    => i_reg_out,
              output => i_inc_out
			  );
	
    U_COMP : entity work.ltecomp(BHV)
        generic map (width => width)
        port map (in1 => i_reg_out,
                  in2 => n_reg_out,
                  result => i_le_n
				  );

    U_OUTPUT_REG : entity work.reg(BHV)
        generic map(width => width)
        port map (clk    => clk,
                  rst    => rst,
                  ld     => result_ld,
                  input  => y_reg_out,
                  output => result
                  );

end STR;




