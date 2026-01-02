library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;
use work.cordic_lut_pkg.all;

entity tb_cordic_unit is
end entity;

architecture sim of tb_cordic_unit is
    signal clk   : std_logic := '0';
    signal en    : std_logic := '0';
    signal dir   : std_logic := '0';
    signal x_in  : q8_24 := (others => '0');
    signal y_in  : q8_24 := (others => '0');
    signal z_in  : q8_24 := (others => '0');
    signal iter  : integer range 0 to N_ITER-1 := 0;
    signal x_out : q8_24;
    signal y_out : q8_24;
    signal z_out : q8_24;
    signal done  : std_logic := '0';

    signal xsh_test : q8_24;
    signal ysh_test : q8_24;
    signal shid_test : integer;

    constant CLK_PERIOD : time := 10 ns;

begin
    dut : entity work.cordic_unit
        port map (
            clk   => clk,
            en    => en,
            dir   => dir,
            x_in  => x_in,
            y_in  => y_in,
            z_in  => z_in,
            iter  => iter,
            x_out => x_out,
            y_out => y_out,
            z_out => z_out,

	shid_test => shid_test,
	xsh_test => xsh_test,
	ysh_test => ysh_test
        );

    clk <= not clk after CLK_PERIOD / 2;


    stim_proc : process
    begin

        wait for 20 ns;
        en <= '1';

        x_in <= K_INV_Q;
        y_in <= to_signed(integer(0.0 * 2.0**24), y_in'length);
        z_in <= to_signed(integer(0.0 * 2.0**24), z_in'length);

        if z_in >= to_signed(0, z_in'length) then
            dir <= '0';
        else
            dir <= '1';
        end if;

        for i in 0 to N_ITER-1 loop
            iter <= i;

		wait until rising_edge(clk);
		wait for 0 ns;  -- cho delta update

            x_in <= x_out;
            y_in <= y_out;
            z_in <= z_out;


            if z_out >= to_signed(0, z_out'length) then
                dir <= '0';
            else
                dir <= '1';
            end if;
	    
	        report "CORDIC LOOP RESULT:";
		report "x_shift = " & real'image(to_real_q8_24(xsh_test));
        	report "y_shift = " & real'image(to_real_q8_24(ysh_test));
        	report "x_out = " & real'image(to_real_q8_24(x_out));
        	report "y_out = " & real'image(to_real_q8_24(y_out));
        	report "z_out = " & real'image(to_real_q8_24(z_out));
        end loop;

        en <= '0';
        wait for 50 ns;
        assert false report "Simulation finished successfully" severity failure;
    end process;

end architecture;

