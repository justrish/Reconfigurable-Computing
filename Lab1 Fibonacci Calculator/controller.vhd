library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        go   : in  std_logic;
        done : out std_logic;

        -- ctrl outputs
		i_sel	  : out std_logic;
        x_sel     : out std_logic;
        y_sel     : out std_logic;
		i_ld	  : out std_logic;
        x_ld	  : out std_logic;
        y_ld	  : out std_logic;
		n_ld	  : out std_logic;
        result_ld : out std_logic;

        -- ctrl inputs
        i_le_n : in std_logic
        );
end controller;

architecture FSM of controller is
    type state_type is (S_SLEEP, S_LOAD, S_UPDATE, S_DONE);
    signal state,next_state : state_type;
begin

    process(clk, rst)
    begin
        if (rst = '1') then
            state <= S_SLEEP;
        elsif (rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;

    process(go, state, i_le_n)
    begin
		i_sel <= '1';
        x_sel <= '1';
		y_sel <= '1';
		i_ld  <= '0';
        x_ld  <= '0';
        y_ld  <= '0';
        n_ld  <= '0';
        result_ld <= '0';
        done  <= '0';
        next_state <= state;

        case state is
      
            when S_SLEEP =>
                if (go = '1') then
					done <= '0';
                    next_state <= S_LOAD;
					x_ld <= '1';
					y_ld <= '1';
					i_ld <= '1';
					n_ld <= '1';
					i_sel <= '1';
					x_sel <= '1';
					y_sel <= '1';
                end if;
            
            when S_LOAD =>
				if (i_le_n = '1') then
					next_state <= S_UPDATE;
				else 
					next_state <= S_DONE;
					result_ld <='1';
				end if;
				x_ld <= '0';
				y_ld <= '0';
				i_ld <= '0';
				n_ld <= '0';
 
            when S_UPDATE =>
				if ( i_le_n  = '1') then
					next_state <= S_LOAD;
					i_sel <= '0';
					x_sel <= '0';
					y_sel <= '0';
					x_ld <= '1';
					y_ld <= '1';
					i_ld <= '1';
					n_ld <= '1';
				else
					result_ld <= '1';
					next_state <= S_DONE;
				end if;
    
            when S_DONE =>
                done   <= '1';
				result_ld <= '0';
                if (go = '0') then
                    next_state <= S_SLEEP;
                end if;

            when others =>
                    null;
        end case;
    end process;

end FSM;






