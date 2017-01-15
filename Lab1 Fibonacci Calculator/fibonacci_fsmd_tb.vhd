library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fibonacci_fsmd_tb is
end fibonacci_fsmd_tb;

architecture TB of fibonacci_fsmd_tb is

    constant WIDTH   : positive := 8;
    constant TIMEOUT : time     := 1 ms;

    signal clkEn  : std_logic                          := '1';
    signal clk    : std_logic                          := '0';
    signal rst    : std_logic                          := '1';
    signal go     : std_logic                          := '0';
    signal done   : std_logic;
    signal n      : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal result : std_logic_vector(WIDTH-1 downto 0);
begin

    UUT : entity work.fibonacci(FSMD)
        generic map (
            WIDTH => WIDTH)
        port map (
            clk    => clk,
            rst    => rst,
            go     => go,
            done   => done,
            n      => n,
            result => result);
	
    clk <= not clk and clkEn after 20 ns;

    process

        function fibonacci (n : integer)
            return std_logic_vector is

            variable x, y, i,regN,temp : integer;
        begin
			regN := n;
            i := 3;
            x := 1;
			y := 1;
            while (i <= regN) loop
                temp := x+y;
				x :=y;
				y :=temp;
				i := i+1;
			end loop;

            return std_logic_vector(to_unsigned(y, WIDTH));

        end fibonacci;

    begin

        clkEn <= '1';
        rst   <= '1';
        go    <= '0';
        n     <= std_logic_vector(to_unsigned(0, WIDTH));
        wait for 200 ns;

        rst <= '0';
        for i in 0 to 5 loop
            wait until clk'event and clk = '1';
        end loop;  -- i

        for j in 1 to 2**WIDTH-1 loop

            go <= '1';
            n  <= std_logic_vector(to_unsigned(j, WIDTH));
            wait until done = '1' for TIMEOUT;
            assert(done = '1') report "Done never asserted." severity warning;
            assert(result = fibonacci(j)) report "Incorrect fibonacci" severity warning;
			
            go <= '0';
            wait until clk'event and clk = '1';

        end loop;

        clkEn <= '0';
        report "DONE!!!!!!" severity note;

        wait;

    end process;

end TB;
