library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity tb_cordic_top is
end entity;

architecture sim of tb_cordic_top is
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal start     : std_logic := '0';
    signal z_in      : q8_24     := (others => '0');

    signal y_out     : q8_24;
    signal done      : std_logic;

    -- debug
    signal en_range  : std_logic;
    signal en_init   : std_logic;
    signal en_cordic : std_logic;
    signal en_result : std_logic;

    signal x_test    : q8_24;
    signal y_test    : q8_24;
    signal z_test    : q8_24;
    signal r_test    : q8_24;
    signal k_test    : integer;
    signal iter_test : integer range 0 to N_ITER;

    constant CLK_PERIOD : time := 10 ns;

begin
    clk <= not clk after CLK_PERIOD/2;

    dut : entity work.cordic_top
        port map (
            clk       => clk,
            rst       => rst,
            start     => start,
            z_in      => z_in,
            y_out     => y_out,
            done      => done,

	rang => en_range,
	cordic => en_cordic,
	init => en_init,
	result => en_result,

            x_test    => x_test,
            y_test    => y_test,
            z_test    => z_test,
            r_test    => r_test,
            k_test    => k_test,
            iter_test => iter_test
        );

    ------------------------------------------------------------------
    -- STIMULUS
    ------------------------------------------------------------------
    process
    begin
        rst <= '1';
        wait for 3 * CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;

        --------------------------------------------------
        -- TEST 1
        --------------------------------------------------
	wait until rising_edge(clk);
        z_in  <= to_signed(integer(-2.0 * 2.0**24), z_in'length);
	report "TEST in = " & real'image(to_real_q8_24(z_in));
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        wait until rising_edge(clk);

        report "TESTS FINISHED";
	report "RESULT out = " & real'image(to_real_q8_24(y_out));

        --------------------------------------------------
        -- TEST 
        --------------------------------------------------
	wait until rising_edge(clk);
        z_in  <= LN2_Q;
	report "TEST in = " & real'image(to_real_q8_24(z_in));
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        wait until rising_edge(clk);

        report "TESTS FINISHED";
	report "RESULT out = " & real'image(to_real_q8_24(y_out));
	
        wait;
    end process;
end architecture;

