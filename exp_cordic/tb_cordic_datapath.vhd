library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity tb_cordic_datapath is
end entity;

architecture sim of tb_cordic_datapath is

    constant CLK_PERIOD : time := 10 ns;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';

    signal en_range  : std_logic := '0';
    signal en_init   : std_logic := '0';
    signal en_cordic : std_logic := '0';
    signal en_result : std_logic := '0';

    signal z_in  : q8_24 := (others => '0');
    signal y_result : q8_24;
    signal done  : std_logic;

    signal r_test : q8_24;
    signal k_test : integer;
    signal x_test : q8_24;
    signal y_test : q8_24;
    signal z_test : q8_24;

    signal kr_test : integer;
    signal rr_test : q8_24;

    signal z_sign : std_logic;
    signal iter   : integer range 0 to N_ITER;

begin
    dut : entity work.cordic_datapath
        port map (
            clk       => clk,
            rst       => rst,
            en_range  => en_range,
            en_init   => en_init,
            en_cordic => en_cordic,
            en_result => en_result,
            z_in      => z_in,
            y_result  => y_result,
            done      => done,

            r_test    => r_test,
            k_test    => k_test,
            x_test    => x_test,
            y_test    => y_test,
            z_test    => z_test,

	    kr_test   => kr_test,
 	    rr_test   => rr_test,

            iter      => iter
        );

    clk <= not clk after CLK_PERIOD/2;

    ------------------------------------------------------------------
    -- STIMULUS
    ------------------------------------------------------------------
    process
    begin
        rst <= '1';
        wait for 2*CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;


        z_in <= to_signed(integer(-2.0 * 2.0**24), z_in'length);
        wait for CLK_PERIOD;


	wait until rising_edge(clk);
	wait for 5 ns;
	en_range <= '1';
	wait until rising_edge(clk);
	wait for 5 ns;
	en_range <= '0';


	wait until rising_edge(clk);
        report "RANGE DONE: k=" & integer'image(k_test);


        wait until rising_edge(clk);
	en_init <= '1';
        wait until rising_edge(clk);
        en_init <= '0';


        wait until rising_edge(clk);
        report "INIT: "&
        	 " x = " & real'image(to_real_q8_24(x_test)) &
        	 " y = " & real'image(to_real_q8_24(y_test)) &
        	 " z = " & real'image(to_real_q8_24(z_test));


	wait until rising_edge(clk);
        for i in 0 to N_ITER-2 loop
	    en_cordic <= '1';
            wait until rising_edge(clk);
	    en_cordic <= '0';
	    wait until rising_edge(clk);
            report "ITER " & integer'image(iter) &
        	 " x = " & real'image(to_real_q8_24(x_test)) &
        	 " y = " & real'image(to_real_q8_24(y_test)) &
        	 " z = " & real'image(to_real_q8_24(z_test));
        end loop;


	wait until rising_edge(clk);
        en_result <= '1';
        wait until rising_edge(clk);
        en_result <= '0';
        wait until done = '1';
        report "RESULT y_out = " & real'image(to_real_q8_24(y_result));


	wait until rising_edge(clk);
	rst <= '1';
        wait for 2*CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;


        wait for 10*CLK_PERIOD;
        assert false report "SIMULATION FINISHED" severity failure;
    end process;

end architecture;
