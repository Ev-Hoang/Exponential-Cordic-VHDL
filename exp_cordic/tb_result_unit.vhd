library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity tb_result_unit is
end entity;

architecture sim of tb_result_unit is

    signal clk   : std_logic := '0';
    signal en    : std_logic := '0';
    signal x_in  : q8_24 := (others => '0');
    signal y_in  : q8_24 := (others => '0');
    signal k_in  : integer := 0;
    signal y_out : q8_24;
    signal done  : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin
    dut : entity work.result_unit
        port map (
            clk   => clk,
            en    => en,
            x_in  => x_in,
            y_in  => y_in,
            k_in  => k_in,
            y_out => y_out,
            done  => done
        );
    clk <= not clk after CLK_PERIOD/2;

    ------------------------------------------------------------------
    -- STIMULOUS
    ------------------------------------------------------------------
    process
        variable expected : signed(31 downto 0);
    begin

        --------------------------------------------------
        -- TEST 1: x = 1.0, y = 2.0, k = 1
        -- y_out = (1 + 2) << 1 = 6.0
        --------------------------------------------------
        x_in <= to_signed(integer(1.0 * 2.0**24), 32);
        y_in <= to_signed(integer(2.0 * 2.0**24), 32);
        k_in <= 1;

        en <= '1';
        wait until rising_edge(clk);
        en <= '0';

        wait until done = '1';
        wait until rising_edge(clk); -- chu?n FSMD

        expected := to_signed(integer(6.0 * 2.0**24), 32);

        assert y_out = expected
            report "FAIL TEST 1"
            severity error;

        --------------------------------------------------
        -- TEST 2: x = -0.5, y = 0.25, k = 2
        -- y_out = (-0.25) << 2 = -1.0
        --------------------------------------------------
        x_in <= to_signed(integer(-0.5 * 2.0**24), 32);
        y_in <= to_signed(integer( 0.25 * 2.0**24), 32);
        k_in <= 2;

        en <= '1';
        wait until rising_edge(clk);
        en <= '0';

        wait until done = '1';
        wait until rising_edge(clk);

        expected := to_signed(integer(-1.0 * 2.0**24), 32);

        assert y_out = expected
            report "FAIL TEST 2"
            severity error;

        --------------------------------------------------
        report "ALL TESTS PASSED" severity note;
        wait;
    end process;

end architecture;

