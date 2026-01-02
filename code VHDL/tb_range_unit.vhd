library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity tb_range_unit is
end;

architecture sim of tb_range_unit is
    signal clk  : std_logic := '0';
    signal en   : std_logic := '0';
    signal t_in : q8_24 := (others => '0');

    signal k_out : integer;
    signal r_out : q8_24;
    signal done  : std_logic;

    signal mul_test : q16_48;
begin

    -- DUT
    uut: entity work.range_unit
        port map (
            clk   => clk,
            en    => en,
            t_in  => t_in,
            k_out => k_out,
            r_out => r_out,
	    mul_test => mul_test
        );

    -- clock
    clk <= not clk after 5 ns;

process
    variable r_i : integer;
begin
    --------------------------------------------------
    -- TEST 2: t = ln2
    --------------------------------------------------
    en   <= '1';
    t_in <= resize(LN2_Q, 32);

    wait until rising_edge(clk);
    en <= '0';

    wait until done = '1';
    wait until rising_edge(clk); 

    r_i := to_integer(r_out);
    assert k_out = 1 report "FAIL t=ln2 k" severity error;
    assert abs(r_i) < 5 report "FAIL t=ln2 r" severity error;

    report "in  = " & real'image(to_real_q8_24(t_in));
    report "mul = " & real'image(to_real_q8_24(resize( mul_test(63 downto 24), 32)));

    --------------------------------------------------
    report "ALL RANGE_UNIT FSMD TESTS PASS" severity note;
    wait;
end process;


end;

