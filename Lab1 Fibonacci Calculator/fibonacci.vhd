library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fibonacci is
    generic (
        WIDTH : positive := 8);
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        go     : in  std_logic;
        done   : out std_logic;
        n     : in  std_logic_vector(WIDTH-1 downto 0);
        result : out std_logic_vector(WIDTH-1 downto 0));
end fibonacci;

architecture FSMD of fibonacci is
    type state_type is (S_SLEEP, S_COND, S_UPDATE, S_DONE);
    signal state : state_type;

    signal i, regN			: unsigned(width-1 downto 0);
	signal x, y , temp		: std_logic_vector(width -1 downto 0);

begin  
    process(clk, rst)
    begin
        if (rst = '1') then
            result <= (others => '0');
            done   <= '0';
            state  <= S_SLEEP;
			regN <= (others => '0');
			i   <= (others => '0');
			x   <= (others => '0');
            y	<= (others => '0');
			temp <= (others=> '0');
        elsif (rising_edge(clk)) then
            case state is
                when S_SLEEP =>
                    if (go = '1') then
                        state <= S_COND;
						done  <= '0';
						regN <= unsigned(n);
						i   <= to_unsigned(3,width);
						x   <= std_logic_vector(to_unsigned(1,width));
						y	<= std_logic_vector(to_unsigned(1,width));
                    end if;

                when S_COND =>
                    if (i <= regN) then
						temp <= std_logic_vector(unsigned(x) + unsigned(y));
                        state <= S_UPDATE;
                    else
                        state <= S_DONE;
                    end if;
					
				when S_UPDATE =>
                    x <= y;
					y <= temp;
					i <= i+1;
                    state <= S_COND;
                    
                when S_DONE =>
                    result <= std_logic_vector(y);
                    done   <= '1';
                    if (go = '0') then
                        state <= S_SLEEP;
                    end if;

                when others =>
                    null;

            end case;
        end if;

    end process;

end FSMD;  

architecture FSM_D of fibonacci is
    signal i_sel, x_sel, y_sel				: std_logic;
    signal i_ld, n_ld, x_ld, y_ld			: std_logic;
    signal i_le_n,result_ld					: std_logic;
	
begin
	U_DATAPATH : entity work.datapath(STR)
        generic map (width => width)
        port map (
            clk    => clk,
            rst    => rst,
			n 	   => n,
            i_sel  => i_sel,   
            x_sel  => x_sel,  
			y_sel  => y_sel,  
			i_ld   => i_ld,  
			x_ld   => x_ld,  
			y_ld   => y_ld,  
			n_ld   => n_ld,  
			result_ld => result_ld,
			i_le_n => i_le_n,
			result => result
            );
	
    U_CONTROLLER : entity work.controller(FSM)
        port map (
            clk    => clk,
            rst    => rst,
			go 	   => go,
            i_sel  => i_sel,   
            x_sel  => x_sel,  
			y_sel  => y_sel,  
			i_ld   => i_ld,  
			x_ld   => x_ld,  
			y_ld   => y_ld,  
			n_ld   => n_ld,  
			result_ld => result_ld,
			i_le_n => i_le_n,
			done => done
            );
end FSM_D;


