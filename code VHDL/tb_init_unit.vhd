library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity tb_init_unit is
end entity;

architecture sim of tb_init_unit is

    constant CLK_PERIOD : time := 10 ns;

    signal clk  : std_logic := '0';
    signal en   : std_logic := '0';

    signal r_in : q8_24 := (others => '0');
    signal x_out, y_out, z_out : q8_24;
    signal done : std_logic;

begin

    dut : entity work.init_unit
        port map (
            clk   => clk,
            en    => en,
            r_in  => r_in,
            x_out => x_out,
            y_out => y_out,
            z_out => z_out,
            done  => done
        );

    clk <= not clk after CLK_PERIOD/2;

    process
    begin
        wait for CLK_PERIOD;

        r_in <= to_signed(integer(0 * 2.0**24), 32);

        en <= '1';
        wait for CLK_PERIOD;
        en <= '0';

        wait until rising_edge(clk);

        report "INIT DONE = " & std_logic'image(done);
        	report "x_out = " & real'image(to_real_q8_24(x_out));
        	report "y_out = " & real'image(to_real_q8_24(y_out));
        	report "z_out = " & real'image(to_real_q8_24(z_out));

        assert x_out = K_INV_Q
            report "ERROR: x_out != K_INV_Q"
            severity error;

        assert y_out = to_signed(0, 32)
            report "ERROR: y_out != 0"
            severity error;

        assert z_out = r_in
            report "ERROR: z_out != r_in"
            severity error;

        assert done = '1'
            report "ERROR: done not asserted"
            severity error;

        wait until rising_edge(clk);
        assert done = '0'
            report "ERROR: done not deasserted"
            severity error;

        wait for 5*CLK_PERIOD;
        assert false report "SIMULATION FINISHED" severity failure;
    end process;

end architecture;

